ORG $01BC74
cpu_code:
    ; Leftover from hijack, don't touch
    INC $602C
    BIT $6002

    SEP #$20
    changeAnimalFriends1:
        LDA $72E0
        ORA $6034
        CMP #$24
        BNE .end
        LDA $54A5
        CMP #$00
        BNE .alterFriendStatus
        INC $54A5
        LDA #$05
        STA $5557
        STZ $5556
        STZ $5558
        STZ $5559
        BRA .end
        .alterFriendStatus:
            DEC $5557
            LDA $5557
            CMP #$FF
            BNE .end
            LDA #$FF
            STA $5558
            STZ $54A5
        .end:

    changeAnimalFriends2:
        LDA $72E0
        ORA $6034
        CMP #$14
        BNE .end
        LDA $54A5
        CMP #$00
        BNE .alterFriendStatus
        INC $54A5
        STZ $5556
        STZ $5557
        STZ $5558
        STZ $5559
        BRA .end
        .alterFriendStatus:
            INC $5557
            LDA $5557
            CMP #$06
            BNE .end
            LDA #$FF
            STA $5557
            STA $5558
            STZ $54A5
        .end:

    RoomReset:
        REP #$20
        LDA !p1hold_BYsSudlrAXLR
        AND #$0010
        ORA $6038
        CMP #$4010
        BNE +
        SEP #$20
        LDA #$01
        STA $39C1 ; set room reload byt
        LDA #$0F  ; freeze game state, needs improvement. enemies don't freeze
        STA $05A2
        STA $0620
        
        +

SEP #$20
RTL
