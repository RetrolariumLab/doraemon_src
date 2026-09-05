; Address-ordered Doraemon PRG bank 1 semantic include map
; Generated deterministically from config/source_modules.json
; Keep byte-identical through make verify

.segment "PRG1"

; $8000-$827C: Bank 1 reset, NMI, input, mapper switching, and cross-bank gateways
.include "../common/bank1_boot_and_gateways.asm"
; $827D-$8443: World 2 stage sequence, compressed-screen selection, and row decoding control
.include "../world2/screen_streaming.asm"
; $8444-$88A3: World 2 compressed row expansion, palette catalog, PPU transfer services, and RTS dispatch tables
.include "../world2/ppu_screen_services.asm"
; $88A4-$8C5C: World 2 initialization, frame loop, and player flight state
.include "../world2/main_loop_and_player.asm"
; $8C5D-$8F4A: World 2 player animation, weapon state, and projectile creation
.include "../world2/player_weapons.asm"
; $8F4B-$92EB: World 2 enemy and projectile behavior handlers
.include "../world2/enemies_and_projectiles.asm"
; $92EC-$9660: World 2 collision tests, object spawning, and frame services
.include "../world2/collision_and_spawning.asm"
; $9661-$98F7: World 2 metasprite composition, OAM placement, and entity spawning
.include "../world2/sprite_rendering.asm"
; $98F8-$9B45: World 2 entity-pool clearing, enemy traversal, and collision dispatch
.include "../world2/enemy_dispatch.asm"
; $9B46-$9D4D: World 2 early indirect enemy-state handlers
.include "../world2/enemy_handlers_early.asm"
; $9D4E-$9F83: World 2 middle indirect enemy-state handlers
.include "../world2/enemy_handlers_middle.asm"
; $9F84-$A0DB: World 2 late indirect enemy-state handlers
.include "../world2/enemy_handlers_late.asm"
; $A0DC-$A611: World 2 later enemy handlers, metasprites, and movement tables
.include "../world2/enemy_handlers.asm"
; $A612-$A80A: World 2 scrolling, stage progress, and boss-state services
.include "../world2/stage_progress.asm"
; $A80B-$AC2F: World 2 audio-effect arbitration, RTS dispatch, and handlers
.include "../world2/audio_effects.asm"
; $AC30-$ACE3: World 2 APU write helpers, presentation data, and channel reset
.include "../world2/audio_apu_helpers.asm"
; $ACE4-$AE22: World 2 four-channel music sequencer and stream interpreter
.include "../world2/music_engine.asm"
; $AE23-$B11A: World 2 music RTS table, command handlers, and stream reader
.include "../world2/music_commands.asm"
; $B11B-$B9CD: World 2 APU period tables, track headers, and music streams
.include "../world2/music_data.asm"
; $B9CE-$BA9E: World 2 unindexed CadEditor prefix and exact 208-entry metatile palette table
.include "../world2/data/block_attributes.asm"
; $BA9F-$BDDE: World 2 exact 208-entry metatile CHR-tile quads
.include "../world2/data/small_blocks.asm"
; $BDDF-$BEDD: World 2 stage bytecode and 208-bit metatile collision bitmap
.include "../world2/data/stage_sequence.asm"
; $BEDE-$BFCB: World 2 standard 119-entry compressed-screen pointer table
.include "../world2/data/screen_pointer_table.asm"
; $BFCC-$D52C: World 2 early compressed screen streams with embedded enemy tokens
.include "../world2/data/screen_streams_1.asm"
; $D52D-$EA4E: World 2 middle compressed screen streams with embedded enemy tokens
.include "../world2/data/screen_streams_2.asm"
; $EA4F-$FFF9: World 2 late compressed screen streams ending at the vector overlap
.include "../world2/data/screen_streams_3.asm"
; $FFFA-$FFFF: Bank 1 NMI, RESET, and IRQ vectors
.include "../common/bank1_vectors.asm"
