PORTB = 0x6000
PORTA = 0x6001 
DDRB = 0x6002
DDRA = 0x6003

E = 0b10000000
RW = 0b01000000
RS = 0b00100000

    .org 0x8000

reset: 
    lda #0b11111111 ;ff Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B

    lda #0b11100000 ;sets some of port A pins to output Sets A register binary is read right to left, therefore the highest bits are set to output here
    sta DDRA


    lda #0b00111000 ; Swt 8-bit mode, 2 line display, and 5x8 font. function set
    jsr lcd_instruction


; end of step 2
    
    lda #0b00001111 ; display on or off
    jsr lcd_instruction

; end of step 3
 
    lda #0b00000110 ; Entry mode set
    jsr lcd_instruction

;end of step 4

    lda #"H" ; writes H to screen
    jsr print_char
    lda #"e" 
    jsr print_char
    lda #"l" 
    jsr print_char
    lda #"l" 
    jsr print_char
    lda #"o" 
    jsr print_char
    lda #" " 
    jsr print_char
    lda #"w" 
    jsr print_char
    lda #"o" 
    jsr print_char
    lda #"r" 
    jsr print_char
    lda #"l" 
    jsr print_char
    lda #"d" 
    jsr print_char


loop:
    jmp loop

lcd_instruction:
    ldx #0xff
    txs

    sta PORTB
    lda #0
    sta PORTA
    lda #E
    sta PORTA
    lda #0
    sta PORTA
    rts

print_char:
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA
    rts

    .org 0xfffc
    .word reset
    .word 0x0000