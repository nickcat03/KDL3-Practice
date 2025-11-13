; Save and Restore code
; DMA to VRAM could possibly be replaced with routine at $0087CB which loads tiles from WRAM (at least for autosaving)

!sfx_save_state = #$0037
!sfx_load_state = #$0012

save_state:

   REP #$30
   LDA !sfx_save_state          ;Sound effect played
   STA !current_sfx
   JSL !play_sfx

   JSR enable_vblank

   REP #$30
   TSC                     ; Transfer stack pointer
   PHA                     ; Push it to the stack for now

   .mvn_instructions:
       REP #$20

       LDX #$0000          ; Data copy starts
       LDY #$8000          ; Copy SaveRAM $400000-$407FFF to $408000-$40FFFF
       LDA #$7FFF
       MVN $40,$40 

       LDX #$3000          ; Copy SA-1 IRAM $003000-$0037FF to $42F800-$42FFFF
       LDY #$F800
       LDA #$07FF
       MVN $00,$42
                          
       LDX #$0000          ; This game sucks
       LDY #$0000          ; Copy all of WRAM cuz yolo
       LDA #$FFFF
       MVN $41,$7E

       LDX #$0000
       LDY #$0000
       LDA #$F7FF
       MVN $42,$7F

       LDA #$0000          ; Reset
       MVN $00,$00


   .dma_instructions:
       SEP #$20
       LDX #$0000      ; add comments here later as per the restore code
       STX $2116
       LDX #$0000      
       STX $4302       
       LDA #$43        
       STA $4304       
       LDX #$FFFF
       STX $4305       
       LDA #$39        
       STA $4301       
       LDA #$81        
       STA $4300       
       LDA #$01        
       STA $420B            

   JSR disable_vblank

   PLA          ; Push the stack saved earlier to the temp variable for the stack
   STA $410000

   ; LDA #$01
   ; STA !QSQL_transfer_mode             ; Tell SA-1 to save stack pointer
   ; LDA #$02
   ; STA !QSQL_offset

   REP #$30

   RTS

restore_state: 

   REP #$30
   LDA !sfx_load_state          ;Sound effect played
   STA !current_sfx
   JSL !play_sfx

   JSR enable_vblank

   REP #$30
   LDA $410000                 ; Restore stack pointer
   TCS

   .restore_music
        SEP #$20
        LDA !savestate_music            
        CMP !current_music_mirror
        BEQ +
        STA !current_music
        REP #$30
        JSL !load_music
        +
    
    REP #$30

   ;LDA !sound_buffer           ; sometimes sounds do not play if this is not saved
   ;STA !save_sound_buffer
   ;LDA !sound_bank_1
   ;STA !save_sound_bank_1
   ;REP #$20
   ;LDA !sound_bank_2     ; make sure sound banks are reloaded if they are different
   ;STA !save_sound_bank_2

   .restore_sram_sa1

       LDX #$8000          ; Data copy starts
       LDY #$0000          ; Copy SaveRAM $400000-$407FFF to $408000-$40FFFF
       LDA #$7FFF
       MVN $40,$40 

       LDX #$F800          ; Copy SA-1 IRAM $003000-$0037FF to $42F800-$42FFFF
       LDY #$3000
       LDA #$07FF
       MVN $00,$42
                          
       LDX #$0000          ; This game sucks
       LDY #$0000          ; Copy all of WRAM cuz yolo
       LDA #$FFFF
       MVN $7E,$41

       LDX #$0000
       LDY #$0000
       LDA #$F7FF
       MVN $7F,$42

       LDA #$0000          ; Reset
       MVN $00,$00

   .restore_vram:
       SEP #$20
       LDX #$0000
       STX $2116
       LDX #$0002      ;Source Offset into source bank
       STX $4302       ;Set Source address lower 16-bits
       LDA #$43        ;Source bank
       STA $4304       ;Set Source address upper 8-bits
       LDX #$FFFF      ;# of bytes to copy 
       STX $4305       ;Set DMA transfer size
       LDA #$18        ;$2118 is the destination, so
       STA $4301       ;  set lower 8-bits of destination to $18
       LDA #$01        ;Set DMA transfer mode: auto address increment
       STA $4300       ;  using write mode 1 (meaning write a word to $2118/$2119)
       LDA #$01        ;The registers we've been setting are for channel 0
       STA $420B       ;  so Start DMA transfer on channel 0 (LSB of $420B)

   JSR disable_vblank

   ;LDA #$02
   ;STA !QSQL_transfer_mode         ; Tell SA-1 to restore stack pointer
   ;LDA #$02
   ;STA !QSQL_offset

   ;LDA !save_sound_buffer          ; apply previous sound buffer so consecutive sound plays
   ;STA !sound_buffer
   ;LDA !save_sound_bank_1
   ;STA !sound_bank_1
   ;REP #$30
   ;LDA !save_sound_bank_2
   ;STA !sound_bank_2

   RTS

enable_vblank:

   SEP #$20

   STZ $4200           ; Disable NMI
   ;STZ $420C           ; Disable HDMA

   - LDA $4212
   BPL -

   LDA #$80
   STA $2100           ; Force blank
   RTS

disable_vblank:

   SEP #$20

   - LDA $4212
   BPL -

   LDA $4210           ; Clear NMI flag

   ;LDA #$81
   LDA #$BF
   STA $4200           ; NMI enable
   LDA #$A8 
   STA $4209           ; Set IRQ hblank period so HUD displays correctly
   LDA #$0F 
   STA $2100           ; Exit force blank
   LDA #$0A
   STA !QSQL_timer     ; Set amount of frames until next QSQL is allowed

   REP #$30

   RTS

; Code responsible for saving and loading the SA-1 stack pointer