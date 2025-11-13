;KDL3 Practice Hack

; compile to FastROM
!_F = $800000

; give the cartridge more SRAM
ORG !_F+$00FFD8
        db $08

; These are ran first because they are not part of the main code block
incsrc "src/defines.asm"
incsrc "src/hex_edits.asm"
incsrc "src/hijacks.asm"
;incsrc "src/hud.asm"

; All of these are ran together because they are all going to be placed in the blank space in ROM
ORG $00F140
incsrc "src/cpu.asm"
;incsrc "src/sa1.asm"

; make sure the ROM is expanded to the full 1MBit
ORG !_F+$1FFFFF
        db $EA