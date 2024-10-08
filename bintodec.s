; Define port addresses
PORTB = 0x6000 ; Port B address
PORTA = 0x6001 ; Port A address
DDRB = 0x6002 ; Data Direction Register for Port B address
DDRA = 0x6003 ; Data Direction Register for Port A address

E = 0b10000000 ;enable
RW = 0b01000000 ; read/write, well this sets it to write mode
RS = 0b00100000 ; register select

value= 0x0200
mod10 = 0x0202

; Reset routine
    .org 0x8000 ; Set relative start location
reset: 
    ; Initialize stack pointer
    ldx #0xff
    txs

    ; Enable output on Port B for all pins
    lda #0b11111111 ; ff Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B

    ; Set some Port A pins to output (right-to-left, highest bits first)
    lda #0b11100000 
    sta DDRA

    ; Configure LCD display settings
    lda #0b00111000 ; Set 8-bit mode, 2 line display, and 5x8 font. function set
    jsr lcd_instruction
    lda #0b00001111 ; Display on or off
    jsr lcd_instruction
    lda #0b00000110 ; Entry mode set
    jsr lcd_instruction
    lda #0b00000001 ; Clear display
    jsr lcd_instruction


; beignning of the conversion
    lda number ; Loads the lower 8 bits of the 16-bit number into the accumulator aka a register
    sta value
    lda number + 1 ; Loads upper byte of value into accumulator
    sta value + 1

    lda #0 
    lda mod10
    sta mod10 + 1



end: ; end of code
    jmp end

number: .word 1729 ; 1729 is the number to be converted to decimal

lcd_wait:
    pha ; push accumulator to stack
    lda #0b00000000;ff Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B

lcd_busy:
    lda #RW ; load accumulator with operataion to enable write to port A. you would never really want to read from port A, thats for setting the data direction and enabling the screen
    sta PORTA ; register A is still output, but B is input
    lda #( RW | E) ; enable. since read is enabled, you read
    sta PORTA
    lda PORTB
    and #0b10000000
    bne lcd_busy ; if zero processor flag is set to 1, loop to lcd_wait

    lda #RW
    sta PORTA   ; clear RS/RW/E bits

    lda #0b11111111 ; ff Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B
    pla ; pull accumulator from stack
    rts

lcd_instruction:
    jsr lcd_wait
    sta PORTB
    lda #0      ; clear RS/RW/E bits
    sta PORTA
    lda #E      ; Set E bit to send instruction
    sta PORTA
    lda #0
    sta PORTA   ; Clear RS/RW/E bits after instruction send
    rts
 
; Print a character on the LCD display
print_char:
    jsr lcd_wait
    sta PORTB
    lda #RS ; Load register select value to Port A
    sta PORTA
    lda #( RS | E)
    sta PORTA
    lda RS
    sta PORTA
    rts

    .org 0xfffc
    .word reset
    .word 0x0000