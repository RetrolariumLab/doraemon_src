; Underground camera tracking on one axis

.macro CameraEntry name
    ::.ident(.sprintf("Bank0_Label_%04X", CameraCpuBase + (* - CameraStart))):
name:
.endmacro

.macro EmitUndergroundCamera playerPosition, axisDelta, forwardThreshold, maxStep, scrollBackward, scrollForward
CameraStart:
    LDA #$00
    STA World1ScreenDeltaX
    STA World1ScreenDeltaY
    LDA playerPosition
    SEC
    SBC #$6E
    BCS TestForward
    EOR #$FF
    SEC
    ADC #$00
    STA World1UndergroundAxisScrollBudget
    CMP #(maxStep+1)
    BCC StepBackward
    LDA #maxStep
    STA World1UndergroundAxisScrollBudget

    CameraEntry StepBackward
    LDA World1UndergroundAxisScrollCoarse
    ORA World1UndergroundAxisScrollFine
    BEQ ApplyDelta
    LDA World1UndergroundAxisScrollFine
    SEC
    SBC #$01
    AND #$07
    STA World1UndergroundAxisScrollFine
    CMP #$07
    BNE ScrollBackward
    DEC World1UndergroundAxisScrollCoarse

    CameraEntry ScrollBackward
    JSR scrollBackward
    DEC World1UndergroundAxisScrollBudget
    BNE StepBackward
    BEQ ApplyDelta

    CameraEntry TestForward
    LDA playerPosition
    SEC
    SBC #forwardThreshold
    BCC ApplyDelta
    STA World1UndergroundAxisScrollBudget
    CMP #maxStep
    BCC IncrementForwardBudget
    LDA #(maxStep-1)
    STA World1UndergroundAxisScrollBudget

    CameraEntry IncrementForwardBudget
    INC World1UndergroundAxisScrollBudget

    CameraEntry StepForward
    LDA World1UndergroundAxisScrollCoarse
    CMP World1UndergroundAxisScrollLimit
    BEQ ApplyDelta
    LDA World1UndergroundAxisScrollFine
    CLC
    ADC #$01
    AND #$07
    STA World1UndergroundAxisScrollFine
    BNE ScrollForward
    INC World1UndergroundAxisScrollCoarse

    CameraEntry ScrollForward
    JSR scrollForward
    DEC World1UndergroundAxisScrollBudget
    BNE StepForward

    CameraEntry ApplyDelta
    LDA playerPosition
    CLC
    ADC axisDelta
    STA playerPosition
    JSR World1_ApplyCameraDeltaToEntities
    RTS
.endmacro
