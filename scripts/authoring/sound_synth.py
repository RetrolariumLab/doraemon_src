#!/usr/bin/env python3
"""Host-side player for Doraemon's native four-channel music bytecode."""

from __future__ import annotations

from dataclasses import dataclass, field
import math
from pathlib import Path
import struct
import sys
from typing import Any
import wave


SCRIPTS = Path(__file__).resolve().parent.parent
if str(SCRIPTS) not in sys.path:
    sys.path.insert(0, str(SCRIPTS))

from scripts.validation.audio import audio_streams


NTSC_FRAME_RATE = 60.0988
CPU_FREQUENCY = 1_789_773.0
DEFAULT_SAMPLE_RATE = 44_100
DEFAULT_PREVIEW_FRAMES = 1_202
CHANNEL_NAMES = ("Pulse 1", "Pulse 2", "Triangle", "Noise")
TABLE_LAYOUTS = {
    0: (0xEE34, 0xA7, 0xC7),
    1: (0xB11B, 0xA8, 0xC8),
    2: (0xC92C, 0xA7, 0xC7),
    3: (0xA30F, 0xA7, 0xC7),
}
NOISE_DIVISORS = (4, 8, 16, 32, 64, 96, 128, 160, 202, 254, 380, 508,
                  762, 1016, 2034, 4068)


@dataclass(frozen=True)
class LaneEvent:
    start_frame: int
    duration_frames: int
    frequency: float
    note: str
    source_address: int
    volume: int


@dataclass(frozen=True)
class ChannelLane:
    name: str
    events: tuple[LaneEvent, ...]


@dataclass(frozen=True)
class ChannelFrame:
    frequency: float = 0.0
    volume: int = 0
    duty: int = 2
    noise_mode: bool = False


@dataclass(frozen=True)
class DecodedTrack:
    lanes: tuple[ChannelLane, ...]
    frames: tuple[tuple[ChannelFrame, ...], ...]


@dataclass
class _ChannelState:
    index: int
    pointer: int
    saved_pointer: int
    duration: int = 1
    duration_code: int = 1
    base_volume: int = 0xFF
    envelope_volume: int = 0xFF
    envelope_step: int = 0
    envelope_enabled: bool = False
    volume: int = 0
    hardware_envelope_period: int = 0
    hardware_envelope_divider: int = 0
    hardware_envelope_volume: int = 0
    hardware_envelope_loop: bool = False
    hardware_envelope_active: bool = False
    duty: int = 2
    pitch_offset: int = 0
    fixed_pitch: int = 0
    fixed_pitch_enabled: bool = False
    loop_start: int = 0
    loop_exit: int = 0
    loop_limit: int = 0
    loop_iteration: int = 0
    call_return: int = 0
    noise_repeats: int = 0
    noise_retrigger_enabled: bool = False
    frequency: float = 0.0
    noise_mode: bool = False
    ended: bool = False
    events: list[LaneEvent] = field(default_factory=list)


class SynthError(ValueError):
    """The edited native stream cannot be rendered safely."""


def _bank_byte(prg: bytes, bank: int, address: int) -> int:
    offset = bank * audio_streams.BANK_SIZE + address - audio_streams.CPU_BASE
    if not 0 <= offset < len(prg):
        raise SynthError(f"bank {bank} address ${address:04X} is outside PRG")
    return prg[offset]


def _stream_memory(driver: dict[str, Any]) -> dict[int, int]:
    memory: dict[int, int] = {}
    for segment in driver["segments"]:
        cursor = audio_streams.number(segment["address"])
        for text in segment["events"]:
            token = audio_streams.parse_event(str(text), cursor)
            for value in token.raw:
                if cursor in memory and memory[cursor] != value:
                    raise SynthError(f"conflicting stream byte at ${cursor:04X}")
                memory[cursor] = value
                cursor += 1
    return memory


def midi_name(frequency: float) -> str:
    if frequency <= 0:
        return "rest"
    midi = round(69 + 12 * math.log2(frequency / 440.0))
    names = ("C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B")
    return f"{names[midi % 12]}{midi // 12 - 1}"


class _Sequencer:
    def __init__(
        self,
        document: dict[str, Any],
        prg: bytes,
        driver_index: int,
        header_index: int,
    ) -> None:
        try:
            self.driver = document["drivers"][driver_index]
            self.header = self.driver["headers"][header_index]
        except (IndexError, KeyError) as exc:
            raise SynthError("selected track header is outside the music document") from exc
        self.prg = prg
        self.bank = int(self.driver["bank"])
        if self.bank not in TABLE_LAYOUTS:
            raise SynthError(f"unsupported audio bank {self.bank}")
        self.period_base, self.noise_relative, self.envelope_relative = (
            TABLE_LAYOUTS[self.bank]
        )
        self.memory = _stream_memory(self.driver)
        pointers = [audio_streams.number(value) for value in self.header["channels"]]
        if len(pointers) != 4:
            raise SynthError("track header does not contain four channels")
        self.channels = [
            _ChannelState(index, pointer, pointer)
            for index, pointer in enumerate(pointers)
        ]
        self.global_pitch_offset = 0

    def read(self, state: _ChannelState) -> tuple[int, int]:
        address = state.pointer
        try:
            value = self.memory[address]
        except KeyError as exc:
            raise SynthError(
                f"channel {state.index} reads outside reachable streams at ${address:04X}"
            ) from exc
        state.pointer = (state.pointer + 1) & 0xFFFF
        return address, value

    def table(self, relative: int, index: int) -> int:
        return _bank_byte(self.prg, self.bank, self.period_base + relative + index)

    def configure_timbre(self, state: _ChannelState, value: int) -> None:
        if state.index == 2:
            return
        if state.envelope_enabled:
            state.envelope_step = self.table(self.envelope_relative, value) | 0x80
        else:
            state.hardware_envelope_period = min(value >> 1, 15)

    def configure_duration(self, state: _ChannelState, value: int) -> None:
        state.duration_code = value
        if not state.fixed_pitch_enabled:
            self.configure_timbre(state, value)

    def pitch_frequency(self, state: _ChannelState, note: int) -> float:
        base = self.table(0x94, state.index)
        pitch = (note + base + self.global_pitch_offset + state.pitch_offset) & 0xFF
        if pitch >= 74:
            raise SynthError(
                f"channel {state.index} pitch index ${pitch:02X} is outside the APU table"
            )
        lo = self.table(0, pitch * 2)
        hi = self.table(0, pitch * 2 + 1)
        period = lo | hi << 8
        divisor = 32 if state.index == 2 else 16
        return CPU_FREQUENCY / (divisor * (period + 1))

    def update_envelope(self, state: _ChannelState) -> None:
        if state.index == 2:
            return
        if state.envelope_enabled:
            delta = (state.envelope_step << 1) & 0xFF
            if state.envelope_step & 0x80:
                state.envelope_volume = max(0, state.envelope_volume - delta)
            else:
                total = state.envelope_volume + delta
                state.envelope_volume = total if total <= 0xFF else 0
            state.volume = state.envelope_volume >> 4
            return
        self.clock_hardware_envelope(state)

    @staticmethod
    def restart_hardware_envelope(
        state: _ChannelState, period: int, loop: bool
    ) -> None:
        state.hardware_envelope_period = period
        state.hardware_envelope_divider = period
        state.hardware_envelope_volume = 15
        state.hardware_envelope_loop = loop
        state.hardware_envelope_active = True
        state.volume = 15

    @staticmethod
    def clock_hardware_envelope(state: _ChannelState) -> None:
        if not state.hardware_envelope_active:
            return
        # The APU envelope clocks at roughly 240 Hz, four times per NTSC game frame.
        for _quarter_frame in range(4):
            if state.hardware_envelope_divider:
                state.hardware_envelope_divider -= 1
                continue
            state.hardware_envelope_divider = state.hardware_envelope_period
            if state.hardware_envelope_volume:
                state.hardware_envelope_volume -= 1
            elif state.hardware_envelope_loop:
                state.hardware_envelope_volume = 15
        state.volume = state.hardware_envelope_volume

    def noise_event(
        self, state: _ChannelState, address: int, value: int, frame: int
    ) -> None:
        repeats = value & 0x0F
        repeats = 256 if repeats == 0 else repeats
        state.noise_repeats = repeats - 1
        period_index = (value >> 4) & 0x0F
        duration = max(1, state.duration_code)
        state.duration = duration
        # A zero period index makes the native driver skip all four APU
        # writes. It consumes time while the preceding envelope decays; table
        # entry zero is not a new, ultrasonic noise timbre.
        if period_index == 0:
            state.noise_retrigger_enabled = False
            state.events.append(
                LaneEvent(
                    frame,
                    duration * repeats,
                    state.frequency,
                    "noise hold",
                    address,
                    state.volume,
                )
            )
            return
        state.noise_retrigger_enabled = True
        table_index = period_index * 4
        control = self.table(self.noise_relative, table_index)
        period = self.table(self.noise_relative, table_index + 2)
        if state.envelope_enabled:
            state.hardware_envelope_active = False
            state.volume = state.envelope_volume >> 4
        elif control & 0x10:
            state.hardware_envelope_active = False
            state.volume = control & 0x0F
        else:
            self.restart_hardware_envelope(
                state, control & 0x0F, bool(control & 0x20)
            )
        state.frequency = CPU_FREQUENCY / NOISE_DIVISORS[period & 0x0F]
        state.noise_mode = bool(period & 0x80)
        state.events.append(
            LaneEvent(
                frame,
                duration * repeats,
                state.frequency,
                f"noise {value >> 4:X}",
                address,
                state.volume,
            )
        )

    def note_event(
        self, state: _ChannelState, address: int, value: int, frame: int
    ) -> None:
        duration = max(1, state.duration_code)
        state.duration = duration
        if value == 0:
            state.frequency = 0.0
            note = "rest"
        else:
            state.frequency = self.pitch_frequency(state, value)
            note = midi_name(state.frequency)
            if state.index == 2:
                state.volume = 15
            elif state.envelope_enabled:
                # The current constant-volume register is written before the
                # software envelope accumulator is reset for following frames.
                state.volume = state.envelope_volume >> 4
                state.envelope_volume = state.base_volume
                state.hardware_envelope_active = False
            else:
                self.restart_hardware_envelope(
                    state, state.hardware_envelope_period, False
                )
        state.events.append(
            LaneEvent(
                frame, duration, state.frequency, note, address, state.volume
            )
        )

    def command(self, state: _ChannelState, opcode: int) -> None:
        if opcode == 0xFF:
            state.ended = True
            state.frequency = 0.0
        elif opcode == 0xFE:
            state.pointer = state.saved_pointer
        elif opcode == 0xFD:
            _address, state.loop_limit = self.read(state)
            state.loop_iteration = 1
            state.loop_start = state.pointer
        elif opcode == 0xFC:
            if state.loop_iteration < state.loop_limit:
                state.loop_iteration += 1
                state.loop_exit = state.pointer
                state.pointer = state.loop_start
        elif opcode == 0xFB:
            _address, iteration = self.read(state)
            if iteration < state.loop_iteration and state.loop_exit:
                state.pointer = state.loop_exit
        elif opcode == 0xFA:
            _address, state.fixed_pitch = self.read(state)
            state.fixed_pitch_enabled = True
            self.configure_timbre(state, state.fixed_pitch)
        elif opcode == 0xF9:
            state.fixed_pitch_enabled = False
            state.envelope_enabled = False
            state.hardware_envelope_active = False
        elif opcode == 0xF8:
            _address, value = self.read(state)
            if state.index != 2:
                state.duty = (value >> 6) & 3
            if state.fixed_pitch_enabled:
                self.configure_timbre(state, state.fixed_pitch)
        elif opcode == 0xF7:
            state.saved_pointer = state.pointer
        elif opcode == 0xF6:
            _address, lo = self.read(state)
            _address, hi = self.read(state)
            state.call_return = state.pointer
            state.pointer = lo | hi << 8
        elif opcode == 0xF5:
            _address, self.global_pitch_offset = self.read(state)
        elif opcode == 0xF4:
            _address, value = self.read(state)
            if state.index != 3:
                state.pitch_offset = value
        elif opcode == 0xF3:
            state.pointer = state.call_return
        elif opcode == 0xF2:
            pass
        elif opcode == 0xF1:
            state.pointer = audio_streams.number(self.header["channels"][state.index])
        elif opcode == 0xF0:
            _address, value = self.read(state)
            self.configure_duration(state, value)
        elif opcode == 0xEF:
            _address, value = self.read(state)
            state.base_volume = value
            state.envelope_volume = value
            state.envelope_enabled = True
            state.volume = value >> 4
        else:
            raise SynthError(f"unsupported music command ${opcode:02X}")

    def parse_event(self, state: _ChannelState, frame: int) -> None:
        if state.index == 3 and state.noise_repeats:
            state.noise_repeats -= 1
            state.duration = max(1, state.duration_code)
            if (
                state.noise_retrigger_enabled
                and not state.envelope_enabled
                and state.hardware_envelope_active
            ):
                self.restart_hardware_envelope(
                    state,
                    state.hardware_envelope_period,
                    state.hardware_envelope_loop,
                )
            return
        for _step in range(4096):
            address, opcode = self.read(state)
            if opcode < 0x80:
                if state.index == 3 and opcode:
                    self.noise_event(state, address, opcode, frame)
                else:
                    self.note_event(state, address, opcode, frame)
                return
            if opcode < 0xEF:
                self.configure_duration(state, opcode & 0x7F)
                continue
            self.command(state, opcode)
            if state.ended:
                return
        raise SynthError(f"channel {state.index} command loop has no timed event")

    def decode(self, max_frames: int) -> DecodedTrack:
        if max_frames <= 0:
            raise SynthError("preview frame limit must be positive")
        frames: list[tuple[ChannelFrame, ...]] = []
        for frame in range(max_frames):
            for state in self.channels:
                if state.ended:
                    continue
                state.duration -= 1
                if state.duration <= 0:
                    self.parse_event(state, frame)
                else:
                    self.update_envelope(state)
            frames.append(
                tuple(
                    ChannelFrame(
                        state.frequency,
                        state.volume if state.frequency else 0,
                        state.duty,
                        state.noise_mode,
                    )
                    for state in self.channels
                )
            )
            if all(state.ended for state in self.channels):
                break
        return DecodedTrack(
            tuple(
                ChannelLane(CHANNEL_NAMES[index], tuple(state.events))
                for index, state in enumerate(self.channels)
            ),
            tuple(frames),
        )


def decode_track(
    document: dict[str, Any],
    prg: bytes,
    driver_index: int,
    header_index: int,
    *,
    max_frames: int = DEFAULT_PREVIEW_FRAMES,
) -> DecodedTrack:
    if len(prg) != 0x20000:
        raise SynthError("Doraemon synthesizer requires the complete 128 KiB PRG")
    return _Sequencer(document, prg, driver_index, header_index).decode(max_frames)


class _ApuFilter:
    def __init__(self, sample_rate: int) -> None:
        self.hp90 = self._hp(90.0, sample_rate)
        self.hp440 = self._hp(440.0, sample_rate)
        self.lp14k = self._lp(14_000.0, sample_rate)
        self.i90 = self.o90 = self.i440 = self.o440 = self.output = 0.0

    @staticmethod
    def _hp(cutoff: float, rate: int) -> float:
        rc = 1.0 / (2.0 * math.pi * cutoff)
        return rc / (rc + 1.0 / rate)

    @staticmethod
    def _lp(cutoff: float, rate: int) -> float:
        rc = 1.0 / (2.0 * math.pi * cutoff)
        return (1.0 / rate) / (rc + 1.0 / rate)

    def process(self, value: float) -> float:
        o90 = self.hp90 * (self.o90 + value - self.i90)
        self.i90, self.o90 = value, o90
        o440 = self.hp440 * (self.o440 + o90 - self.i440)
        self.i440, self.o440 = o90, o440
        self.output += self.lp14k * (o440 - self.output)
        return self.output


def _mix(pulse1: float, pulse2: float, triangle: float, noise: float) -> float:
    pulse_sum = pulse1 + pulse2
    pulse = 0.0 if pulse_sum == 0 else 95.88 / (8128.0 / pulse_sum + 100.0)
    tnd_input = triangle / 8227.0 + noise / 12241.0
    tnd = 0.0 if tnd_input == 0 else 159.79 / (1.0 / tnd_input + 100.0)
    return pulse + tnd


def _poly_blep(phase: float, step: float) -> float:
    """Band-limit one discontinuity of a sampled pulse oscillator."""
    if step <= 0:
        return 0.0
    if phase < step:
        position = phase / step
        return position + position - position * position - 1.0
    if phase > 1.0 - step:
        position = (phase - 1.0) / step
        return position * position + position + position + 1.0
    return 0.0


def _pulse_level(phase: float, step: float, duty: float) -> float:
    value = 1.0 if phase < duty else -1.0
    value += _poly_blep(phase, step)
    value -= _poly_blep((phase - duty) % 1.0, step)
    return max(0.0, min(1.0, (value + 1.0) * 0.5))


def render_pcm(
    decoded: DecodedTrack,
    *,
    enabled_channels: set[str] | None = None,
    sample_rate: int = DEFAULT_SAMPLE_RATE,
) -> bytes:
    if sample_rate <= 0:
        raise SynthError("sample rate must be positive")
    if not decoded.frames:
        return b"\0\0"
    sample_count = max(1, round(len(decoded.frames) * sample_rate / NTSC_FRAME_RATE))
    phases = [0.0, 0.0, 0.0]
    noise_phase = 0.0
    noise_lfsr = 1
    output_filter = _ApuFilter(sample_rate)
    pcm = bytearray()
    duties = (0.125, 0.25, 0.5, 0.75)
    for sample_index in range(sample_count):
        frame_index = min(
            len(decoded.frames) - 1,
            int(sample_index * NTSC_FRAME_RATE / sample_rate),
        )
        channels = decoded.frames[frame_index]
        values = [0.0, 0.0, 0.0, 0.0]
        for index in range(3):
            channel = channels[index]
            if enabled_channels is not None and CHANNEL_NAMES[index] not in enabled_channels:
                continue
            phase_step = channel.frequency / sample_rate
            phases[index] = (phases[index] + phase_step) % 1.0
            if not channel.frequency or not channel.volume:
                continue
            if index < 2:
                values[index] = float(channel.volume) * _pulse_level(
                    phases[index], phase_step, duties[channel.duty]
                )
            else:
                values[index] = abs(phases[index] * 4.0 - 2.0) * 7.5
        noise = channels[3]
        if enabled_channels is None or "Noise" in enabled_channels:
            noise_phase += noise.frequency / sample_rate
            while noise_phase >= 1.0:
                noise_phase -= 1.0
                tap = 6 if noise.noise_mode else 1
                feedback = (noise_lfsr & 1) ^ ((noise_lfsr >> tap) & 1)
                noise_lfsr = (noise_lfsr >> 1) | feedback << 14
            if noise.frequency and not noise_lfsr & 1:
                values[3] = float(noise.volume)
        sample = max(-1.0, min(1.0, output_filter.process(_mix(*values)) * 1.35))
        pcm.extend(struct.pack("<h", round(sample * 32767)))
    return bytes(pcm)


def write_preview(
    document: dict[str, Any],
    prg: bytes,
    driver_index: int,
    header_index: int,
    path: Path,
    *,
    enabled_channels: set[str] | None = None,
    max_frames: int = DEFAULT_PREVIEW_FRAMES,
    sample_rate: int = DEFAULT_SAMPLE_RATE,
) -> DecodedTrack:
    decoded = decode_track(
        document, prg, driver_index, header_index, max_frames=max_frames
    )
    pcm = render_pcm(
        decoded, enabled_channels=enabled_channels, sample_rate=sample_rate
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    with wave.open(str(path), "wb") as output:
        output.setnchannels(1)
        output.setsampwidth(2)
        output.setframerate(sample_rate)
        output.writeframes(pcm)
    return decoded
