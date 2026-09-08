-- Interactive native music preview for Doraemon Sound Studio.

local requested_bank = assert(tonumber(os.getenv("DORAEMON_SOUND_PREVIEW_BANK")))
local requested_track = assert(tonumber(os.getenv("DORAEMON_SOUND_PREVIEW_TRACK")))
local requested_name = os.getenv("DORAEMON_SOUND_PREVIEW_NAME") or "selected track"
local max_frames = tonumber(os.getenv("DORAEMON_SOUND_PREVIEW_MAX_FRAMES") or "")
local result_path = os.getenv("DORAEMON_SOUND_PREVIEW_RESULT")

local AUDIO_MUSIC_STATE = 0x02AA
local AUDIO_MUSIC_CONTROL = 0x02AB
local fingerprints = {
    ["07A91020"] = 0,
    ["A51A8D01"] = 1,
    ["41454D4F"] = 2,
    ["4C888A4C"] = 3,
}

local function byte(address)
    return memory.readbyte(address)
end

local function active_bank()
    local signature = string.format(
        "%02X%02X%02X%02X",
        byte(0x8280), byte(0x8281), byte(0x8282), byte(0x8283)
    )
    return fingerprints[signature]
end

local function input_for_frame(frame)
    local input = {}
    if requested_bank == 0 then
        input.start = (frame >= 180 and frame <= 184) or
            (frame >= 220 and frame <= 224)
    elseif requested_bank == 1 then
        input.A = frame >= 150 and frame <= 210
        input.B = input.A
        input.select = frame >= 160 and frame <= 164
        input.start = frame >= 180 and frame <= 184
    elseif requested_bank == 2 then
        input.A = frame >= 150 and frame <= 220
        input.B = input.A
        input.select = (frame >= 160 and frame <= 164) or
            (frame >= 170 and frame <= 174)
        input.start = frame >= 190 and frame <= 194
    end
    return input
end

-- Revision A reaches the World 3 bank but resets on its first gameplay frame.
-- Frame 300 is after the shared chapter setup and before the observed frame-338
-- reset, so the native bank-2 driver still receives the requested track.
local ready_frame = ({[0] = 880, [1] = 300, [2] = 300, [3] = 120})[requested_bank]
local injected = false

while true do
    local frame = emu.framecount()
    joypad.set(1, input_for_frame(frame))
    if not injected and frame >= ready_frame and active_bank() == requested_bank then
        memory.writebyte(AUDIO_MUSIC_CONTROL, 0)
        memory.writebyte(AUDIO_MUSIC_STATE, requested_track)
        injected = true
        if result_path ~= nil and result_path ~= "" then
            local result = assert(io.open(result_path, "w"))
            result:write(string.format(
                "bank=%d,track=%d,frame=%d\n",
                requested_bank, requested_track, frame
            ))
            result:close()
        end
    end
    gui.text(8, 8, "Doraemon Sound Studio")
    gui.text(8, 18, requested_name)
    gui.text(8, 28, injected and "Playing - close FCEUX to stop" or "Entering chapter...")
    emu.frameadvance()
    if max_frames ~= nil and emu.framecount() >= max_frames then
        assert(injected, "sound preview never reached its requested PRG bank")
        emu.exit()
        break
    end
end
