#include "xc.inc"
GLOBAL _mysqrt
PSECT mytext,local,class=CODE,reloc=2    
    
_mysqrt:
    MOVFF WREG, 0x03
    MOVLW 0x00
    MOVWF 0x01
    MOVLW 0x0F
    MOVWF 0x02
sqrt_loop:
    MOVFF 0x01, WREG
    MULWF 0x01
    MOVFF PRODL, WREG
    CPFSGT 0x03
    GOTO sqrt_found
    INCF 0x01
    DECFSZ 0x02
    GOTO sqrt_loop

sqrt_found:
    MOVFF 0x01, WREG
	
RETURN	
