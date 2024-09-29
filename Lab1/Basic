List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    ;A1
    MOVLW 0x1F ;input
    MOVWF 0x00 
    MOVWF 0x02
    MOVLW 0x01 ;input
    MOVWF 0x01
    ADDWF 0x02
    
    ;A2
    MOVLW 0x7F ;input
    MOVWF 0x10 
    MOVWF 0x12
    MOVLW 0x6F ;input
    MOVWF 0x11
    SUBWF 0x12
    
    ;compare
    MOVF 0x02, W ;move A1 value to WREG
    ; if A1 = A2 do equal
    equal: 
        CPFSEQ 0x12
        GOTO bigger
	MOVLW 0xBB         
        MOVWF 0x20 
	GOTO finish
    ; if A1 < A2 do bigger	
    bigger:
        CPFSGT 0x12
	GOTO smaller
	MOVLW 0xCC         
        MOVWF 0x20
	GOTO finish
    ; if A1 > A2 do smaller	
    smaller: 
	MOVLW 0xAA         
        MOVWF 0x20
	GOTO finish
    finish:
        end
