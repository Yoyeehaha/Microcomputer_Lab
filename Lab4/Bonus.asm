List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    CLRF 0x00
    CLRF 0x01
    CLRF 0x10
    CLRF 0x11
    CLRF 0x12
    
    MOVLW 0x00 ; F0 = 0
    MOVWF 0x10
    MOVLW 0x01 ; F1 = 1
    MOVWF 0x11
    MOVLW 0x0F ; n
    MOVWF 0x13
    
    start:
	RCALL fib
	DECFSZ 0x13
	GOTO start
	GOTO finish
    
    fib:
	MOVFF 0x10, 0x12
	MOVF 0x11, W
	MOVFF 0x12, 0x11
	ADDWF 0x10
	BTFSC STATUS, C ;if there is a carry after add, then 0x00 + 1
	INCF 0x00
	BCF STATUS, C
	RETURN
    
    finish: 
	MOVFF 0x10, 0x01 ;move to 0x01
	CLRF 0x10
	CLRF 0x11
	CLRF 0x12
	end
