List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00

    MOVLW 0x01 ;input
    MOVLB 0x1
    MOVWF 0x00 ,1 ;put into 0x100
    MOVLW 0x00 ;input
    MOVWF 0x16 ,1 ;put into 0x116
    
    setup:
        LFSR 0, 0x100 ;FSR0 point to 0x100
        LFSR 1, 0x116 ;FSR1 point to 0x116
	MOVLW 0x06 ;do 6 times
	MOVLB 0x0
	MOVWF 0x00, 1
    
    start:
        MOVF INDF0, W ;move FSR0 to WREG
	ADDWF INDF1, W ;add W and FSR1 and put it in WREG
	MOVWF PREINC0 ;pointer + 1 then move the value from WREG to 0x101, 0x102...
	
	MOVF INDF0, W ;move FSR0 to WREG
	ADDWF POSTDEC1, W ;add W and FSR1 and put it in WREG then pointer - 1
	MOVWF INDF1 ;move the value from WREG to 0x115, 0x114...
	
	DECFSZ 0x00 ;skip next line if 0x00 = 0
	GOTO start
	
end
