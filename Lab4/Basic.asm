List p=18f4520 
    #include<p18f4520.inc>
    CONFIG OSC = INTIO67
    CONFIG WDT = OFF
    org 0x00
    
    Sub_Mul macro xh,xl,yh,yl
        ;Sub
        BSF STATUS,C
	MOVLW xl
	MOVWF 0x01
	MOVLW xh
	MOVWF 0x00
	MOVLW yl
	SUBWFB 0x01 ; F - WREG - C(bar)
	BTFSS STATUS, C ;if carry flag = 1(means xl > yl) then skip next line
	DECF 0x00
	MOVLW yh
	SUBWF 0x00
	
	;Mul
	MOVF 0x00, W
	MULWF 0x01
	MOVFF PRODH, 0x10
	MOVFF PRODL, 0x11
    endm
	
    Sub_Mul 0x0A, 0x04, 0x04, 0x02
    ;Sub_Mul 0x02, 0x0C, 0x00, 0x0F
	
end
