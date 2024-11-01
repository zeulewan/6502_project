; Define port addresses
PORTB = 0x6000 ; Port B
PORTA = 0x6001 ; Port A
DDRB = 0x6002  ; Data Direction Register B
DDRA = 0x6003  ; Data Direction Register A
PCR = 0x600c   ; Peripheral Control Register
IFR = 0x600d   ; Interrupt Flag Register
IER = 0x600e   ; Interrupt Enable Register

E = 0b10000000  ; Enable
RW = 0b01000000 ; Read/Write (0 = write)
RS = 0b00100000 ; Register Select

value = 0x0200   ; 2 bytes
mod10 = 0x0202   ; 2 bytes
message = 0x0204 ; 6 bytes
counter = 0x020a ; 2 bytes


; Reset routine
    .org 0x8000 ; Set relative start location
reset:
    ; Initialize stack pointer
    ldx #0xff
    txs
    cli ; Clear interrupt disable bit

    lda #0x82
    sta IER ; Set interrupt enable
    lda #00
    sta PCR

    ; Set Port B pins to output
    lda #0b11111111
    sta DDRB

    ; Set Port A pins to input
    lda #0b00000000
    sta DDRA

    jsr lcd_init

    ; Configure LCD display
    lda #0b00101000 ; 4-bit mode, 2 lines, 5x8 font
    jsr lcd_instruction
    lda #0b00001111 ; Display on
    jsr lcd_instruction
    lda #0b00000110 ; Entry mode
    jsr lcd_instruction
    lda #0b00000001 ; Clear display
    jsr lcd_instruction

    lda #0
    sta counter
    sta counter + 1

loop:
    lda #0b00000010 ; Home cursor
    jsr lcd_instruction

    lda #0
    sta message

; Begin number conversion
    sei
    lda counter     ; Load lower byte
    sta value
    lda counter + 1 ; Load upper byte
    sta value + 1
    cli

divide:
    ; Initialize remainder
    lda #0
    sta mod10
    sta mod10 + 1
    clc

    ldx #16 ; load x register with ascii 16
divloop:
    ; Rotate quotient and remainder
    rol value
    rol value + 1
    rol mod10
    rol mod10 + 1

    ; a,y = dividend - divisor:
    sec ; set carry 1
    lda mod10
    sbc #10 ; subtract 10
    tay ; save low byte in y
    lda mod10 + 1
    sbc #0 ; subtract 0. since it's a subtract with carry, a reg ends up in 255 if carry is 0 from previous subtraction. SBC inverts C and subtracts it
    bcc ignore_result ; branch if dividend < divisor. branch if carry = 0
    sty mod10
    sta mod10 + 1
    
ignore_result:
    dex ; decrement x register
    bne divloop ; branch if zero flag is not set, aka brach not equal. a reg is not zero question: why isn't it just a bcc divloop?
    rol value
    rol value + 1

    lda mod10
    clc ; clear carry
    adc #"0" ; adding 0 converts it to an ascii number
    jsr push_char

    lda value 
    ora value + 1 
    bne divide ; this says if there is still shit to divide, keep looping

    ldx #0
print_message:
    lda message,x
    beq loop
    jsr print_char
    inx
    jmp print_message


number: .word 1729 ; 1729 is the number to be converted to decimal

push_char:
    pha
    ldy #0

char_loop
    lda message,y   ; load a reg with message bit
    tax             ; transfer a reg to x reg
    pla             ; pull stack to a reg
    sta message,y   ; store a reg in message bit
    iny
    txa             ; where is null terminator coming from
    pha
    bne char_loop

    pla
    sta message, y
    rts

lcd_wait:
    pha ; push accumulator to stack
    lda #0b11110000; 1 output, 0 input. outputting to control pins
    sta DDRB 

lcd_busy:
    lda #RW ; tells LCD to output
    sta PORTB 
    lda #(RW | E)
    sta PORTB
    lda PORTB
    pha
    lda #RW 
    sta PORTB 
    lda #(RW | E)
    sta PORTB
    lda PORTB
    pla
    and #0b00001000
    bne lcd_busy ; if zero processor flag is set to 1, loop to lcd_wait

    lda #RW
    sta PORTB   ; clear RS/RW/E bits
    lda #0b11111111 ; ff Sets all pins on port B to output
    sta DDRB ; 6002 is register for data direction for register B
    pla ; pull to accumulator from stack
    rts

lcd_init:
  lda #%00000010 ; Set 4-bit mode
  sta PORTB
  ora #E
  sta PORTB
  and #%00001111
  sta PORTB
  rts

lcd_instruction: ; changed for 4 bit LCD operation 
    jsr lcd_wait
    pha
    lsr 
    lsr
    lsr ; logical shift right. not rotate right. fills left bit with zero 0010 1000 -> 0000 0010
    lsr
    sta PORTB
    ora #E ; 10000000 or 1000 0010 -> 1000 0010
    sta PORTB
    eor #E         ; Clear E bit
    sta PORTB
    pla
    and #%00001111 ; Send low 4 bits
    sta PORTB
    ora #E         ; Set E bit to send instruction
    sta PORTB
    eor #E         ; Clear E bit
    sta PORTB
    rts

; Print character on LCD
print_char:
    jsr lcd_wait
    pha 
    lsr
    lsr 
    lsr 
    lsr
    ora #RS
    sta PORTB
    ora #E
    sta PORTB
    eor #E
    sta PORTB

    pla 
    and #%00001111 
    ora #RS
    sta PORTB
    ora #E
    sta PORTB 
    eor #E          ; possible to just send all zeros
    sta PORTB
    rts

nmi:
irq: 
    pha 
    txa
    pha

    inc counter 
    bne exit_irq
    inc counter + 1

exit_irq:

    ldx #0xff
delay:    
    dex
    bne delay

    bit PORTA  

    pla
    tax
    pla

    rti

    .org 0xfffa
    .word nmi
    .word reset
    .word irq