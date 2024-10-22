#include "xc.inc"
GLOBAL _gcd
PSECT mytext,local,class=CODE,reloc=2  
    
_gcd:
    MOVFF 0x01, TRISA ;A_low
    MOVFF 0x02, TRISB ;A_high
    MOVFF 0x03, TRISC ;B_low
    MOVFF 0x04, TRISD ;B_high
    
    ;keep a > b
    gcd_loop:
	MOVF TRISB, W
	SUBWF TRISD, W 
	BZ check_low_bits
	BN lower_bit_sub   ;A_high > B_high
	
    check_low_bits:	
	MOVF TRISA, W
	CPFSGT TRISC 
	GOTO lower_bit_sub
	
    swap:	
	;swap two number
	MOVFF TRISB, LATB
        MOVFF TRISA, LATA
        MOVFF TRISD, TRISB
	MOVFF TRISC, TRISA
	MOVFF LATB, TRISD
	MOVFF LATA, TRISC
	
;;;;;;;SUB;;;;;;;;;;;;	
    lower_bit_sub:
	MOVF TRISC, W
	SUBWF TRISA
	BC higher_bit_sub
	DECF TRISB
        
    higher_bit_sub:
	
	MOVF TRISD, W
	SUBWF TRISB
;;;;;;;SUB;;;;;;;;;
	
    check_if_zero:	
	MOVF TRISD, W
	BNZ check_lower
	
    check_lower:
	MOVF TRISC, W
	BZ finish
	GOTO gcd_loop
	
    finish:
	MOVFF TRISA, 0x01  ;A_low
	MOVFF TRISB, 0x02  ;A_high
	MOVFF TRISC, 0x03  ;B_low
	MOVFF TRISD, 0x04  ;B_high 	
	
    
    RETURN


