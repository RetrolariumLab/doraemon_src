# World 3 PPU update queue

World 3 stages PPU writes in a 256-byte wrapping ring at `$0500-$05FF`.
`World3PpuQueueWriteIndex` (`$6C`) belongs to producers and
`World3PpuQueueReadIndex` (`$6B`) belongs to the NMI consumer. Equal indexes
mean that the queue is empty.

Each record is self-sized:

| Offset | Meaning |
| ---: | --- |
| 0 | PPU address high bits 0-6; bit 7 requests PPU increment 32 |
| 1 | PPU address low byte |
| 2 | Payload length |
| 3... | Bytes written to `PPU_DATA` |

`World3_QueuePpuBlock` appends the general record. The palette path emits a
fixed `$3F00`, 32-byte record and mirrors its payload at `$0480-$049F`.
Single-byte and attribute-quadrant writers use the same format. Before the
largest 35-byte record is appended, `World3_WaitForPpuQueueSpace` requires the
ring to be empty or to have at least `$24` bytes between its modulo-256
indexes.

While rendering is enabled, the common bank-2 NMI optionally performs page-3
OAM DMA before `World3_NmiFrameServices` drains one PPU queue record, resets
the PPU address, and applies the scroll pair and nametable bits. The consumer
explicitly initializes a one-record budget, so the retail path drains at most
one record per NMI even though it also retains a `$30` payload-byte threshold
check.

When rendering is disabled, the NMI bypasses PPU and OAM work. Producers then
call `World3_DrainPpuQueueIfRenderingDisabled` after appending so bulk setup
writes can execute synchronously. Re-enabling rendering first waits for equal
read/write indexes, waits for a vblank edge, restores OAM and scroll state,
and finally writes `$1E` to `PPU_MASK`.

The coordinate helpers accept tile X/Y in registers and wrap them at 32 by 30
tiles. They return the computed nametable or attribute PPU address in
`World3PpuAddressHigh:World3PpuAddressLow`; the attribute helper additionally
returns the matching RAM-shadow offset.

`config/world3_ppu_queue.json` makes this model executable. The release gate
checks the record geometry and capacity invariant, all 15 owned RAM symbols,
23 active or dormant PPU-path routines, and 13 code signatures against the
canonical PRG and semantic symbol registry.
