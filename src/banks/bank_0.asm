; Address-ordered Doraemon PRG bank 0 semantic include map
; Generated deterministically from config/reconstruction/source_modules.json
; Keep byte-identical through make verify

.segment "PRG0"

; $8000-$827C: Bank 0 reset, NMI, input, mapper switching, and cross-bank gateways
.include "../common/bank0_boot_and_gateways.asm"
; $827D-$856B: World 1 initialization, main frame loop, and queued PPU writes
.include "../world1/main_loop_and_ppu.asm"
; $856C-$888E: World 1 player state, directional movement, and camera-relative positioning
.include "../world1/player_and_camera.asm"
; $888F-$8A6B: World 1 entity traversal, low-state RTS dispatch, and shared update helpers
.include "../world1/entity_update_dispatch.asm"
; $8A6C-$8D21: World 1 object coordinate stepping, animation, and collision helpers
.include "../world1/object_motion.asm"
; $8D22-$8F9D: World 1 persistent object masks, spawning, and entity-slot initialization
.include "../world1/object_persistence_and_spawning.asm"
; $8F9E-$9200: World 1 entity direction, motion, and bounds helpers
.include "../world1/entity_motion_helpers.asm"
; $9201-$95CA: World 1 entity collision scans, damage resolution, and interaction helpers
.include "../world1/entity_collisions.asm"
; $95CB-$9909: World 1 frame synchronization, PPU preparation, and sprite traversal
.include "../world1/frame_rendering.asm"
; $990A-$A380: World 1 metasprite composition, OAM placement, and animation data
.include "../world1/sprite_rendering.asm"
; $A381-$A509: World 1 scroll advancement and nametable edge selection
.include "../world1/map_scrolling.asm"
; $A50A-$A87D: World 1 metatile decoding and incremental nametable streaming
.include "../world1/map_streaming.asm"
; $A87E-$A9EE: World 1 buffered PPU update packet construction
.include "../world1/ppu_update_queue.asm"
; $A9EF-$AAEE: World 1 CadEditor block attribute table
.include "../world1/data/block_attributes.asm"
; $AAEF-$AEEE: World 1 CadEditor small metatile table
.include "../world1/data/small_blocks.asm"
; $AEEF-$B2EE: World 1 CadEditor large metatile table
.include "../world1/data/big_blocks.asm"
; $B2EF-$C2EE: World 1 64 by 64 city map
.include "../world1/data/city_map.asm"
; $C2EF-$C92E: World 1 64 by 25 underground map
.include "../world1/data/underground_map.asm"
; $C92F-$CB60: World 1 city object state initialization and interaction handlers
.include "../world1/city_objects.asm"
; $CB61-$CDB4: World 1 city item interactions and door transition sequence
.include "../world1/city_transitions.asm"
; $CDB5-$D112: World 1 side-view underground initialization, frame loop, and movement
.include "../world1/underground_main.asm"
; $D113-$D3A8: World 1 underground collision tests and manhole return transition
.include "../world1/underground_collisions.asm"
; $D3A9-$D76F: World 1 underground room changes, completion paths, and entity updates
.include "../world1/underground_transitions.asm"
; $D770-$D7A4: World 1 underground transient-object allocation and positioning
.include "../world1/underground_object_spawning.asm"
; $D7A5-$D924: World 1 twelve-record full PPU palette table
.include "../world1/data/palettes.asm"
; $D925-$D988: World 1 underground three-byte object placement records and terminator
.include "../world1/data/underground_object_placements.asm"
; $D989-$DAD9: World 1 city three-byte object placement records and terminator
.include "../world1/data/city_object_placements.asm"
; $DADA-$DBD9: World 1 entity collision and behavior parameter tables
.include "../world1/data/entity_behavior_tables.asm"
; $DBDA-$DEBA: World 1 low-state entity handlers at DBDA through DEBA
.include "../world1/entity_handlers_early.asm"
; $DEBB-$E14A: World 1 low-state entity handlers at DEBB through E14A
.include "../world1/entity_handlers_middle.asm"
; $E14B-$E315: World 1 low-state entity handlers at E14B through E315
.include "../world1/entity_handlers_late.asm"
; $E316-$E68C: World 1 audio-effect arbitration, RTS dispatch, and early handlers
.include "../world1/audio_effect_dispatch.asm"
; $E68D-$E948: World 1 remaining audio-effect handlers
.include "../world1/audio_effect_handlers.asm"
; $E949-$E9FC: World 1 APU write helpers and channel reset
.include "../world1/audio_apu_helpers.asm"
; $E9FD-$EB64: World 1 four-channel music sequencer and command dispatch
.include "../world1/music_engine.asm"
; $EB65-$EE33: World 1 music command handlers and stream reader
.include "../world1/music_commands.asm"
; $EE34-$FFF9: World 1 APU tables, track headers, header-reachable streams, and adjacent unclassified data
.include "../world1/music_data.asm"
; $FFFA-$FFFF: Bank 0 NMI, RESET, and IRQ vectors
.include "../common/bank0_vectors.asm"
