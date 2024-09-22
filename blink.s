PORTB = 0x6000
PORTA = 0x6001 
DDRB = 0x6002
DDRA = 0x6003

    .org 0x8000

reset: 
    lda #0b11111111 ; this sets the data direction of port P on the VIA # means load immediate. load that value, not load the value in that memory address
    sta DDRB ; 6002 is register for data direction for register B

    lda #0b11111111
    sta DDRA

    lda #0x50  ; load accumultor with #$50 # is immediate, load that value, not what is in that address location
    sta PORTB ; put accumulator on PORT B

loop: 
    ror
    sta PORTB
    
    jmp loop

    .org 0xfffc
    .word reset
    .word 0x0000