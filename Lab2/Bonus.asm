List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    MOVLW 0x00 ;input
    MOVWF 0x00
    MOVLW 0x11 ;input
    MOVWF 0x01
    MOVLW 0x22 ;input
    MOVWF 0x02
    MOVLW 0x33 ;input
    MOVWF 0x03
    MOVLW 0x44 ;input
    MOVWF 0x04
    MOVLW 0x55 ;input
    MOVWF 0x05
    MOVLW 0x66 ;input
    MOVWF 0x06
    
    setup:
        LFSR 0, 0x000
	MOVLW 0x00
	MOVWF 0x12 ;L
	MOVLW 0x06 ;0 - 6 inputs
	MOVWF 0x13 ;R
    
    binarySearch:
        MOVF 0x12, W
        ADDWF 0x13, W ;W = R + L
	RRCF WREG, F ; W = W / 2
	MOVWF 0x14
	
	LFSR 1, 0x000 ; Set FSR1 to point to the start of the array
        ADDWF FSR1L, F ; Let FSR1 point to midpoint ;F means store back to FSR1
	
	MOVF INDF1, W ; Load midpoint
        SUBLW 0x22  ; Compare with 0xFE
        BTFSC STATUS, Z ; If the Z in STATUS is not zero(the above line equal to zero), go to found
        GOTO Found 
    
        MOVLW 0x22 ; Compare with 0xFE
        CPFSLT INDF1 ; If 0xFE is larger, skipCB next line
        GOTO searchLower ; If 0xFE is smaller, search the lower half
    
        MOVF 0x14, W ; Load midpoint
        INCF WREG ; Next index
        MOVWF 0x12 ; Update start index (low)
        GOTO continueSearch

    searchLower:
        MOVF 0x14, W ; Load midpoint
        DECF WREG ; Previous index
        MOVWF 0x13 ; Update end index (high)

    continueSearch:
        MOVF 0x12, W ; Load start index
        CPFSLT 0x13 ; If start index lager than end index, skip(not found)
        GOTO binarySearch ; Continue
        GOTO notFound 

    Found:
        MOVLW 0xFF ; Load 0xFF into WREG
        MOVWF 0x11 ; Store at 0x011
        GOTO finish

    notFound:
        MOVLW 0x00 ; Load 0x00 into WREG
        MOVWF 0x11 ; Store at 0x011

    finish:
        CLRF 0x12 
        CLRF 0x13
        CLRF 0x14
    end
