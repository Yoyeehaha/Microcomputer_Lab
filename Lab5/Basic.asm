#include "xc.inc"
GLOBAL _mysqrt
PSECT mytext,local,class=CODE,reloc=2    
    
_mysqrt:
    MOVWF 0x01
    MOVLW 0x0F
    MOVWF 0x03
sqrt_loop:
    MOVFF 0x02, WREG
    MULWF 0x02
    MOVFF PRODL, WREG
    CPFSGT 0x01
    GOTO sqrt_found
    INCF 0x02
    DECFSZ 0x03
    GOTO sqrt_loop

sqrt_found:
    MOVFF 0x02, WREG
	
RETURN		
