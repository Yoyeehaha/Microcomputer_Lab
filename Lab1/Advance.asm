List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0xF7 ;input
    ANDLW 0xF0 ;do AND with 11110000 to take front 4th bits
    MOVWF 0x00 
    MOVWF 0x02
    MOVLW 0x9F ;input
    ANDLW 0x0F ;do AND with 00001111 to take back 4th bits
    MOVWF 0x01
    ADDWF 0x02
    CLRF 0x03
    init:
        MOVLW 0x08 ;check each bit in 0x02
	MOVWF 0x04
    loop:       
        BTFSS 0x02, 0 ;start from right
	INCF 0x03
	RRNCF 0x02 ;move the bit
	DECFSZ 0x04
        GOTO loop

    end
