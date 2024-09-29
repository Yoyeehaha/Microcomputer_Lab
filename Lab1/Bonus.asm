List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    
    MOVLW 0x10 ;input
    MOVWF 0x10
    MOVLW 0xAA ;input
    MOVWF 0x00

    init:
        BTFSC 0x00, 0
        GOTO none
        BTFSC 0x00, 1
        GOTO two
        GOTO four
    ;none
    none: 
        DECF 0x10    
        GOTO rotate
       
    ;2
    two:
        INCF 0x10       
        GOTO rotate    
    ;4
    four:
        INCF 0x10
        INCF 0x10
        GOTO rotate

    ;right rotate
    rotate:
        RRNCF 0x00
    
    ; check if equal to the org one	
    check:
        CPFSEQ 0x00
        GOTO init
        GOTO finish	
	
    ;end
    finish:
        
        end
