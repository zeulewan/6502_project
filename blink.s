    .org $8000

reset: 
    lda #$ff ; # means load immediate. load that value, not load the value in that memory address
    sta $6002 ; $ means hex

loop: 
    lda #$92
    sta $6000
    
    lda #$49
    sta $6000

    lda #$12
    sta $6000

    jmp loop

    .org $fffc
    .word reset
    .word $0000