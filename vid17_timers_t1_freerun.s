; Define port addresses
PORTB = $6000  ; Port B address
PORTA = $6001  ; Port A address
DDRB  = $6002  ; Data Direction Register for Port B
DDRA  = $6003  ; Data Direction Register for Port A
T1CL = $6004   ; Timer 1 Counter Low
T1CH = $6005   ; Timer 1 Counter High
ACR = $600B    ; Auxiliary Control Register
IFR = $600D ; Interrupt Flag Register


; Reset 
    .org $8000      ; Set reset vector starting location

reset:
    lda #%01111111   ; Set all bits of Port A to output
    sta DDRA
    lda #0 
    sta PORTA
    sta ACR
    jsr init_timer

loop:
    inc PORTA
    dec PORTA
    jmp loop

init_timer:
    lda %01111111
    sta ACR
    lda #$50
    lda T1CL
    lda #$c3
    lda T1CH
    rts
    
delay1:
    bit IFR
    bvc delay1
    lda T1CL
    rts 

    .org $fffc
    .word reset
    .word $0000
