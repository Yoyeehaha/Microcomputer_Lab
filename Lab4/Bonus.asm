List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    CLRF 0x00
    CLRF 0x01
    CLRF 0x10
    CLRF 0x11
    CLRF 0x20
    CLRF 0x21
    
    MOVLW 0x00 ; F0 = 0
    MOVWF 0x01
    MOVLW 0x01 ; F1 = 1
    MOVWF 0x11
    MOVLW 0x10 ; n
    MOVWF 0x13
    
    start:
	RCALL fib
	DECFSZ 0x13
	GOTO start
	GOTO finish
    
    fib:
	;higher bits
	MOVFF 0x00, 0x20
	MOVF 0x10, W
	MOVFF 0x20, 0x10
	ADDWF 0x00
    
        ;lower bits
	MOVFF 0x01, 0x21
	MOVF 0x11, W
	MOVFF 0x21, 0x11
	ADDWF 0x01
	BTFSC STATUS, C
	INCF 0x00
	BCF STATUS, C
	RETURN
    
    finish: 
	
	CLRF 0x10
	CLRF 0x11
	CLRF 0x20
	CLRF 0x21
	end
