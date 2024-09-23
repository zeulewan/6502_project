PORTB = 0x6000
PORTA = 0x6001 
DDRB = 0x6002
DDRA = 0x6003

E = 0b10000000
RW = 0b01000000
RS = 0b00100000

    .org 0x8000

reset: 
    lda #0b11111111 ; Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B

    lda #0b11100000 ; binary is read right to left, therefore the highest bits are set to output here
    sta DDRA

    lda #0b00111000 ; Swt 8-bit mode, 2 line display, and 5x8 font. function set
    sta PORTB

    lda #0
    sta PORTA
    
    lda E
    sta PORTA
    
    lda #0
    sta PORTA
; end of step 2
    
    lda #0b00001111 ; display on or off
    sta PORTB

    lda #0
    sta PORTA
    
    lda E
    sta PORTA
    
    lda #0
    sta PORTA
; end of step 3
 
    lda #0b00000110 ; Entry mode set
    sta PORTB

    lda #0
    sta PORTA
    
    lda E
    sta PORTA
    
    lda #0
    sta PORTA
;end of step 4

    lda #"H" ; writes H to screen
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"e" 
    sta PORTB 
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"l" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"l" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA
    
    lda #"o" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA
    
    lda #"," 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #" " 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"w" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"o" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"r" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA
    
    lda #"l" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"d" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

    lda #"!" 
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA

loop:
    jmp loop

    .org 0xfffc
    .word reset
    .word 0x0000