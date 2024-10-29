LIST p=18f4520
#include<p18f4520.inc>

    CONFIG OSC = INTIO67 ; Set internal oscillator to 1 MHz
    CONFIG WDT = OFF     ; Disable Watchdog Timer
    CONFIG LVP = OFF     ; Disable Low Voltage Programming
    
    
    L1 EQU 0x14         ; Define L1 memory location
    L2 EQU 0x15         ; Define L2 memory location
    org 0x00

    ; instruction frequency = 1 MHz / 4 = 0.25 MHz
    ; instruction time = 1/0.25 = 4 ?s
    ; Total_cycles = 2 + (2 + 8 * num1 + 3) * num2 cycles
    ; num1 = 111, num2 = 70, Total_cycles = 62512 cycles
    ; Total_delay ~= Total_cycles * instruction time = 0.25 s
    DELAY macro num1, num2
	local LOOP1         ; Inner loop
	local LOOP2         ; Outer loop

	; 2 cycles
	MOVLW num2          ; Load num2 into WREG
	MOVWF L2            ; Store WREG value into L2

	; Total_cycles for LOOP2 = 2 cycles
	LOOP2:
	MOVLW num1          
	MOVWF L1  

	; Total_cycles for LOOP1 = 8 cycles
	LOOP1:
	NOP                 ; busy waiting
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1, 1        
	BRA LOOP1           ; BRA instruction spends 2 cycles

	; 3 cycles
	DECFSZ L2, 1        ; Decrement L2, skip if zero
	BRA LOOP2           
    endm

    
    start:
	MOVLW 0x0F          ; Set ADCON1 register for digital mode
	MOVWF ADCON1        ; Store WREG value into ADCON1 register
	CLRF PORTA            ; Clear PORTA (turn off all LEDs)
	CLRF PORTB            ; Clear PORTB
	MOVLW 0xF8          ; Set RA0, RA1, RA2 as outputs 
	MOVWF TRISA
	MOVLW 0x01          ; Set RB0 as input 
	MOVWF TRISB

    check_button:
	BTFSC PORTB, 0      ; Check if PORTB bit 0 is low (button pressed)
	BRA check_button     
	BRA light_first_up         ; If button is pressed, branch to lightup
	
    no_light_up:
	BCF LATA, 2
	DELAY d'111', d'70'
	BTFSC PORTB, 0
	BRA no_light_up
	BRA light_first_up
	
    light_first_up:
	BSF LATA, 0
	DELAY d'111', d'70'
	BTFSC PORTB, 0
	BRA light_first_up 
	BRA light_second_up
	
    light_second_up:
        BCF LATA, 0
	BSF LATA, 1
	DELAY d'111', d'70'
	BTFSC PORTB, 0
	BRA light_second_up
	BRA light_third_up
	
    light_third_up:
	BCF LATA, 1
	BSF LATA, 2
	DELAY d'111', d'70'
	BTFSC PORTB, 0
	BRA light_third_up
	BRA no_light_up

    end



