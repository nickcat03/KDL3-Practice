; For CPU
ORG $009490
    JSL cpu_code
    NOP
    NOP

; For NMI
ORG $0082FC
    JSL nmi_code