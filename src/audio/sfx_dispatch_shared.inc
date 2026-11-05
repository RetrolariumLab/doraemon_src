; Effect request queues, timer arbitration, RTS dispatch, and reset

SfxCoreStart:
    CMP #SfxRequestLimit
    BCS ReturnFromQueue
    STX SfxSavedX
    LDX a:AudioEffectRequestState
    BMI StoreRequest
    STY SfxSavedY
    TAY
    LDA a:RequestPriority,X
    CMP a:RequestPriority,Y
    BCC RestoreYAndX
    TYA
    LDY SfxSavedY

    SfxCoreLocal StoreRequest, 2
    STA a:AudioEffectRequestState

    SfxCoreLocal RestoreX, 2
    LDX SfxSavedX

    SfxCoreLocal ReturnFromQueue, 3
    RTS

    SfxCoreLocal RestoreYAndX, 2
    LDY SfxSavedY
    JMP RestoreX

    SfxCoreEntry Audio_QueueEffect
    CMP #SfxRequestLimit
    BCS ReturnFromQueue
    STX SfxSavedX
    LDX #$00
    STX a:AudioCurrentEffectPriority
    STA a:AudioEffectRequestState
    LDX SfxSavedX
    RTS

    SfxCoreEntry Audio_UpdateEffects
    LDX #$03

    SfxCoreLocal TickEffectTimers, 3
    LDA a:AudioEffectTimers,X
    BEQ NextEffectTimer
    DEC a:AudioEffectTimers,X

    SfxCoreLocal NextEffectTimer, 3
    DEX
    BPL TickEffectTimers
    LDA a:AudioEffectRequestState
    BMI SelectUpdateEntry
    TAX
    ORA #$80
    STA a:AudioEffectRequestState
    CPX #SfxRequestLimit
    BCS SelectUpdateEntry
    LDA a:AudioCurrentEffectPriority
    BEQ AcceptRequest
    LDA a:RequestPriority,X
    CMP a:AudioCurrentEffectPriority
    BCC AcceptRequest
    BNE SelectUpdateEntry
    LDA a:AudioEffectRetriggerLock
    BNE SelectUpdateEntry

    SfxCoreLocal AcceptRequest, 3
    LDA a:RequestPriority,X
    STA a:AudioCurrentEffectPriority
    TAX
    LDA #$00
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    BEQ DispatchEffect

    SfxCoreLocal SelectUpdateEntry, 3
    LDX a:AudioCurrentEffectPriority
    INX
    INX

    SfxCoreLocal DispatchEffect, 3
    CPX #SfxDispatchLimit
    BCS Audio_StopCurrentEffect
    LDA a:EffectDispatchTable+1,X
    PHA
    LDA a:EffectDispatchTable,X
    PHA
    RTS

    SfxCoreEntry AudioEffect_UpdateTimedStop
    DEC a:AudioEffectWork0
    BNE AudioEffect_NoOp

    SfxCoreEntry Audio_StopCurrentEffect
    LDA #$00
    STA a:AudioCurrentEffectPriority
    STA a:AudioEffectRetriggerLock

    SfxCoreEntry AudioEffect_NoOp
    RTS

    SfxCoreEntry Audio_ResetEffects
    LDA #$00
    STA a:AudioEffectRetriggerLock
    STA a:$4011
    STA a:AudioEffectTimers
    STA a:AudioEffectTimers+$01
    STA a:AudioEffectTimers+$02
    STA a:AudioEffectTimers+$03
    STA a:APU_TRI_LINEAR
    STA a:APU_NOISE_VOL
    LDA #$18
    STA a:APU_TRI_HI
    LDA #$10
    STA a:APU_PL1_VOL
    STA a:APU_PL2_VOL
    LDA #$0F
    STA a:APU_STATUS
    RTS

.assert SfxCoreStart = SfxCoreCpuBase, lderror, "SFX dispatcher moved"
.assert * - SfxCoreStart = $00C9, error, "SFX dispatcher size changed"
