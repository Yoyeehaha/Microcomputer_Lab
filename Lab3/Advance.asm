List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    ;first input
    MOVLW 0x12 ;input
    MOVWF 0x00
    MOVLW 0xCB ;input
    MOVWF 0x01
    
    ;second input
    MOVLW 0x09 ;input
    MOVWF 0x10
    MOVLW 0x35 ;input
    MOVWF 0x11
    
    MOVFF 0x00, 0x20
    MOVFF 0x01, 0x21
    MOVFF 0x10, 0x22
    MOVFF 0x11, 0x23
    
    setup:
	MOVLW 0x10
	MOVWF 0x04
    
    right_shift:
        BCF STATUS, C
        RRCF 0x23
        BTFSC 0x22, 0
        BSF 0x23, 7
        BTFSS 0x22, 0
        BCF 0x23, 7
        BCF STATUS, C
        RRCF 0x22
    
        BTFSC 0x21, 0
        BSF 0x22, 7
        BTFSS 0x21, 0
        BCF 0x22, 7
        BCF STATUS, C
        RRCF 0x21
    
	BTFSC 0x20, 0
	BSF 0x21, 7
	BTFSS 0x20, 0
	BCF 0x21, 7
	BCF STATUS, C
	RRCF 0x20
	
	DCFSNZ 0x04
	GOTO finish

    check_if_add:
	BTFSC 0x23, 0
	GOTO add
	GOTO right_shift
	
    add:
	MOVF 0x01, W
	ADDWF 0x21, F
	
	MOVF 0x00, W           
        ADDWFC 0x20, F
	
	GOTO right_shift
    finish:
        end
