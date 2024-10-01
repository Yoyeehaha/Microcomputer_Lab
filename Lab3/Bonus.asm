List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x00 ;input
    MOVWF 0x00
    MOVLW 0x41 ;input
    MOVWF 0x01
    
    setup:
        MOVLW 0x08
	MOVWF 0x07
	MOVWF 0x08
	MOVFF 0x00, 0x05
	MOVFF 0x01, 0x06
	MOVF 0x05, W
	BTFSS STATUS, Z ;to check if first 8 bits are all 0
	GOTO start_higher_bit
	GOTO start_lower_bit
    
    start_higher_bit:
	MOVLW 0x0F
	MOVWF 0x02
	GOTO check_each_high_bit
	
    start_lower_bit:
        MOVLW 0x07
	MOVWF 0x02
	GOTO check_each_low_bit
	
    check_each_high_bit:
        BTFSC 0x05, 7
	GOTO last_check_high_bit
	BCF STATUS, C
	RLCF 0x05
	DECFSZ 0x02
	GOTO check_each_high_bit
	
    check_each_low_bit:
        BTFSC 0x06, 7
	GOTO last_check_low_bit
	BCF STATUS, C
	RLCF 0x06
	DECFSZ 0x02
	GOTO check_each_low_bit
	
    last_check_high_bit: ;to check if first 8 bit have another 1
        BTFSC 0x05, 6
	INCF 0x02
	BTFSC 0x05, 6
	GOTO finish
	BCF STATUS, C
	RLCF 0x05
	DECFSZ 0x07
	GOTO last_check_high_bit
	
    then_check_low_bit: ;if first 8 bits do not have 1 then check lower 8 bits
	BTFSC 0x06, 7
	INCF 0x02
	BTFSC 0x06, 7
	GOTO finish
	BCF STATUS, C
	RLCF 0x06
	DECFSZ 0x08
	GOTO last_check_low_bit
        
    last_check_low_bit: ;to check if last 8 bit have another 1
        BTFSC 0x06, 6
	INCF 0x02
	BTFSC 0x06, 6
	GOTO finish
	BCF STATUS, C
	RLCF 0x06
	DECFSZ 0x08
	GOTO last_check_low_bit
	
    finish:
        CLRF 0x05
	CLRF 0x06
	CLRF 0x07
	CLRF 0x08
	end

