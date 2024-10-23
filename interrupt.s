PORTB = 0x6000
PORTA = 0x6001 
DDRB = 0x6002
DDRA = 0x6003

; applies to port A
E = 0b10000000 ;enable
RW = 0b01000000 ; read/write, well this sets it to write mode
RS = 0b00100000 ; register select

    .org 0x8000 ; sets relative start location

reset: 
    ldx #0xff ; init stack pointer
    txs

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
    lda #0b00000001 ; clear display
    jsr lcd_instruction

    
print_message    
    lda message,x
    beq end
    jsr print_char
    inx
    jmp print_message



end: ; end of code
    jmp end

message: .asciiz "Hello world"

lcd_wait:
    pha
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

    lda #0b11111111 ;ff Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B
    pla
    rts
; test
lcd_instruction:
    jsr lcd_wait
    sta PORTB
    lda #0      ; clear RS/RW/E bits
    sta PORTA
    lda #E      ; set E bit to send instruction
    sta PORTA
    lda #0
    sta PORTA   ; clear RS/RW/E bits
    rts

print_char:
    jsr lcd_wait
    sta PORTB
    lda RS
    sta PORTA
    lda #( RS | E) 
    sta PORTA
    lda RS
    sta PORTA
    rts
    


nmi:
    inc counter 
    bne


irq:
    rti 




    .org 0xfffa
    .word nmi
    .word reset
    .word irq

    .word 0x0000