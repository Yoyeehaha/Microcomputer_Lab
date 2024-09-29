List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW b'01011111' ;input
    CLRF TRISA
    MOVWF TRISA
    
    ;left rotate
    BCF STATUS, C
    RLCF TRISA, 1
    
    ;right rotate
    RRCF TRISA, 1
    BTFSC TRISA, 6 ;if bit 6 is 0, skip next line
    BSF TRISA, 7 ; set bit 7 to 1
    BTFSS TRISA, 6 ;if bit 6 is 1, skip next line
    BCF TRISA, 7 ; set bit 7 to 0
    end
