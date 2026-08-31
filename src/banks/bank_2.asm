; Address-ordered Doraemon PRG bank 2 semantic include map
; Generated deterministically from config/source_modules.json
; Keep byte-identical through make verify

.segment "PRG2"

; $8000-$827C: Bank 2 reset, NMI, input, mapper switching, and cross-bank gateways
.include "../common/bank2_boot_and_gateways.asm"
; $827D-$82AC: Embedded World 3 build identification string
.include "../world3/data/build_string.asm"
; $82AD-$875B: World 3 initialization, frame loop, player state, and map position
.include "../world3/main_loop_and_player.asm"
; $875C-$8B67: World 3 world-state progression, object spawning, and player interactions
.include "../world3/world_state_and_objects.asm"
; $8B68-$9191: World 3 entity storage, movement, collision, and behavior dispatch
.include "../world3/entity_runtime.asm"
; $9192-$9A3A: World 3 collision responses, object rewards, and interaction handlers
.include "../world3/collision_and_rewards.asm"
; $9A3B-$9D18: World 3 object script decoding and early behavior handlers
.include "../world3/object_scripts_1.asm"
; $9D19-$A0C3: World 3 object traversal, animation, and later behavior handlers
.include "../world3/object_scripts_2.asm"
; $A0C4-$A5DE: World 3 hierarchical map lookup, tile collision, and interaction state
.include "../world3/map_collision.asm"
; $A5DF-$A8AF: World 3 audio wrappers, nametable streaming, and PPU update preparation
.include "../world3/ppu_streaming.asm"
; $A8B0-$AE11: World 3 room updates, entity collision adjustment, and state tables
.include "../world3/room_updates.asm"
; $AE12-$B1BA: World 3 completion sequence, transition loop, and support routines
.include "../world3/chapter_transition.asm"
; $B1BB-$B405: World 3 frame synchronization, PPU buffers, and metatile update helpers
.include "../world3/frame_and_ppu_helpers.asm"
; $B406-$B6B9: World 3 HUD composition, number rendering, and presentation tables
.include "../world3/hud_rendering.asm"
; $B6BA-$BE0D: World 3 OAM writer, metasprite tables, and palettes
.include "../world3/sprite_data.asm"
; $BE0E-$C015: World 3 audio-effect arbitration, RTS dispatch, and early handlers
.include "../world3/audio_effect_dispatch.asm"
; $C016-$C440: World 3 remaining audio-effect handlers
.include "../world3/audio_effect_handlers.asm"
; $C441-$C4F4: World 3 APU write helpers, presentation data, and channel reset
.include "../world3/audio_apu_helpers.asm"
; $C4F5-$C633: World 3 four-channel music sequencer and stream interpreter
.include "../world3/music_engine.asm"
; $C634-$C92B: World 3 music RTS table, command handlers, and stream reader
.include "../world3/music_commands.asm"
; $C92C-$DDF1: World 3 APU period tables, track headers, and music streams
.include "../world3/music_data.asm"
; $DDF2-$DEF1: World 3 CadEditor block attribute table
.include "../world3/data/block_attributes.asm"
; $DEF2-$E2F1: World 3 CadEditor small metatile table
.include "../world3/data/small_blocks.asm"
; $E2F2-$E6F1: World 3 CadEditor large metatile table
.include "../world3/data/big_blocks.asm"
; $E6F2-$F6F1: World 3 64 by 64 underwater map
.include "../world3/data/map.asm"
; $F6F2-$FFF9: World 3 trailing chapter data and unused fill
.include "../world3/data/bank_tail.asm"
; $FFFA-$FFFF: Bank 2 NMI, RESET, and IRQ vectors
.include "../common/bank2_vectors.asm"
