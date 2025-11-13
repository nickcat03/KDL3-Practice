nmi_code:             ; make sure that a save or load hasn't occured in the last however many frames
    PHB         ; save current databank and set it to $00
    SEP #$30
    LDA #$00
    PHA 
    PLB 
    REP #$30

    LDA !QSQL_timer
    CMP #$0000
    BNE .countdown_QSQL_timer
    .check_save_input:
        LDA !p1hold_BYsSudlrAXLR
        CMP       #%0010000000010000
        BNE .check_load_input
        LDA !p1frame_BYsSudlrAXLR
        CMP        #%0010000000000000  ; R + Select = save state
        BNE .check_load_input
        JSR save_state 

    .check_load_input:
        LDA !p1hold_BYsSudlrAXLR
        CMP       #%0010000000100000
        BNE .vblank_return_to_main_routine
        LDA !p1frame_BYsSudlrAXLR
        CMP        #%0010000000000000  ; L + Select = load state
        BNE .vblank_return_to_main_routine
        JSR restore_state

    ; separate routine above, maybe add it here? probably doesn't matter if it functions the same.
    .check_roomload_input:
        ;LDA !p1hold_BYsSudlrAXLR
        ;AND #$0010
        ;ORA !p1hold_BYsSudlrAXLR
        ;CMP #$0050
        ;BNE .vblank_return_to_main_routine
        ;JSR restore_current_room
        ;BRA .vblank_return_to_main_routine

    .countdown_QSQL_timer:
        DEC !QSQL_timer

    .vblank_return_to_main_routine:
        PLB
        db $F4,$00,$60 ; PEA #$6000
        PLD
        RTL

