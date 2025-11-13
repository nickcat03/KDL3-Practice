; Set lives to 99
ORG $00BA77
    LDA #$0064
; Stop lives from decreasing
ORG $08BC6A
    RTL

; Skip intro and jump directly to title screen
; write BRA $C10077 to jump to file select load and skip opening 
ORG $028038
    db $80, $3D

; Unlock all options (visual)
ORG $018DB6
    ; minigame5
    PLX
    LDA #$0003
    NOP
    RTS

    ; boss butch
    PLX
    LDA #$0003
    NOP
    RTS

    ; jumping
    PLX
    LDA #$0003
    NOP
    RTS

    ; cutscenes
    PLX
    LDA #$0003
    NOP
    RTS

; Unlock all options (selectable)
ORG $018B95
    ; minigame5
    PLX
    LDA #$0003
    NOP
    RTS

    ; boss butch
    PLX
    LDA #$0003
    NOP
    RTS

    ; jumping
    PLX
    LDA #$0003
    NOP
    RTS

    ; cutscenes
    PLX
    LDA #$0003
    NOP
    RTS

; Always spawn stardrop if mission is completed (overwrites 1up give)
; BNE -> BRA
ORG $099FC2
    db $80

; Always refight bosses
ORG $01B01B
    LDA #$0000

; All stages unlocked
ORG $02C38E
    LDA #$0006
ORG $02C3A0
    CMP #$0006
ORG $02C424
    LDA #$0006
ORG $01B16C
    LDA #$0006
ORG $01B17C
    LDA #$0006
ORG $01B1B5
    LDA #$0006
ORG $01AF3D
    LDA #$0006
ORG $02B840
    CMP #$0006
ORG $02B732
    CMP #$0006
ORG $02B713
    LDA #$0006
ORG $02C20E
    CMP #$0006
ORG $02B7B0
    LDA #$0006

; Always skip world cutscenes
ORG $02B457
    LDA #$0001

; Allow pausing on boss fights (can't figure out w6 but everything else works)
ORG $028353
    NOP #2