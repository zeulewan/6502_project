    .org $8000

reset: 
    lda #$ff ; # means load immediate. load that value, not load the value in that memory address
    sta $6002 ; $ means hex

    lda #$50
    sta $6000

loop: 
    ror
    sta $6000
    
    jmp loop

    .org $fffc
    .word reset
    .word $0000