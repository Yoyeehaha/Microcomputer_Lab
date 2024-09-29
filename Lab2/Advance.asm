List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLB 0x1
    MOVLW 0xFF ;input
    MOVWF 0x00, 1
    MOVLW 0x87 ;input
    MOVWF 0x01, 1
    MOVLW 0x8C ;input
    MOVWF 0x02, 1
    MOVLW 0xEF ;input
    MOVWF 0x03, 1
    MOVLW 0x43 ;input
    MOVWF 0x04, 1
    MOVLW 0xA7 ;input
    MOVWF 0x05, 1
    MOVLW 0xD1 ;input
    MOVWF 0x06, 1

    ;we have 7 input so we did it 6 + 5 + 4 + 3 + 2 +1 times
    MOVLW 0x06 ;the outer loop
    MOVWF 0x01
    
    ; I use bubble sort to sort the values 
    setup: ;back to the beginning
        LFSR 0, 0x100
	LFSR 1, 0x101
        MOVFF 0x01, 0x00 ;each time follow the outer loop value
	
    start:
        MOVF INDF0, W
	CPFSGT INDF1 ;skip if A[i + 1] > A[i]
	GOTO swap
	
    movepointer:	
	MOVF POSTINC0, W
	MOVF POSTINC1, W
	DECFSZ 0x00 ;inner loop
	GOTO start
	DECFSZ 0x01 ;outer loop
	GOTO setup
	GOTO finish
	
    swap:
        MOVFF INDF0, 0x02 ;exchange two value
	MOVFF INDF1, INDF0
	MOVFF 0x02, INDF1
	
	GOTO movepointer
    
    finish:
        CLRF 0x02
        end    
