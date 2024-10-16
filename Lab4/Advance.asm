List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOV_F macro a1, a2, a3, b1, b2, b3
	MOVLW a1
	MOVWF 0x00
	MOVLW a2
	MOVWF 0x01
	MOVLW a3
	MOVWF 0x02
	MOVLW b1
	MOVWF 0x10
	MOVLW b2
	MOVWF 0x11
	MOVLW b3
	MOVWF 0x12
    endm
    
    cross_mulsub macro a, aa, b, bb, reg
	MOVF a, W    
	MULWF bb    ;a * bb
	MOVFF PRODL, reg
	MOVF aa, W
	MULWF b     ;aa * b
	MOVF PRODL, W
	SUBWF reg    ;a * bb - b * aa
    endm
    
    MOV_F 0x0B, 0x00, 0x10, 0x0C, 0x00, 0x06
    ;MOV_F 0x03, 0x04, 0x05, 0x06, 0x07, 0x08
    rcall cross
    GOTO finish
    
    cross:
	cross_mulsub 0x01, 0x02, 0x11, 0x12, 0x20
	cross_mulsub 0x02, 0x00, 0x12, 0x10, 0x21
	cross_mulsub 0x00, 0x01, 0x10, 0x11, 0x22	

    finish:
	end
