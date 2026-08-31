; Address-ordered Doraemon PRG bank 3 semantic include map
; Generated deterministically from config/source_modules.json
; Keep byte-identical through make verify

.segment "PRG3"

; $8000-$827C: Reset, NMI, input, mapper switching, and cross-bank gateways
.include "../common/bank3_boot_and_gateways.asm"
; $827D-$8A16: Title flow, menus, and common presentation services
.include "../shell/title_and_presentation.asm"
; $8A17-$8A87: Returning game-over presentation service
.include "../shell/game_over.asm"
; $8A88-$8C3A: Ending initialization and credits scroll loop
.include "../shell/ending.asm"
; $8C3B-$8FF1: World transitions and interstitial cutscenes
.include "../shell/chapter_transitions.asm"
; $8FF2-$9829: Shell PPU updates, text drawing, and presentation data
.include "../rendering/shell_frame_services.asm"
; $982A-$9C1C: Audio-effect request arbitration and primary handlers
.include "../audio/effect_dispatch.asm"
; $9C1D-$9ED7: Remaining audio-effect handlers and APU write helpers
.include "../audio/effect_handlers.asm"
; $9ED8-$A30E: Four-channel music sequencer and stream interpreter
.include "../audio/music_engine.asm"
; $A30F-$BDBB: APU period tables, track headers, and music streams
.include "../audio/music_data.asm"
; $BDBC-$DBBB: First contiguous part of the ending credit stream
.include "../data/ending_credits_1.asm"
; $DBBC-$F9BB: Second contiguous part of the ending credit stream
.include "../data/ending_credits_2.asm"
; $F9BC-$FFF9: Trailing bank 3 data pending format classification
.include "../data/bank3_tail.asm"
; $FFFA-$FFFF: Bank 3 NMI, RESET, and IRQ vectors
.include "../common/bank3_vectors.asm"
