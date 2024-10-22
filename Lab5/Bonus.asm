#include "xc.inc"
GLOBAL _multi_signed
PSECT mytext,local,class=CODE,reloc=2  

_multi_signed:
    ; a is in wreg, b is in 0x01
    MOVWF 0x10    ;put a into 0x10
    MOVFF 0x01, 0x11    ;put b into 0x11
    MOVLW 0x08
    MOVWF 0x04
    
    BTFSS 0x10, 7   ;check if a is negetive, 
    GOTO A_is_positive
    
    A_is_negetive:
	NEGF 0x10
	MOVLW 0x01   ;set a is neg
	MOVWF 0x05
	GOTO check_B
	
    A_is_positive:
	GOTO check_B
	
    check_B:
	BTFSS 0x11, 7   ;check if a is negetive, 
	GOTO B_is_positive
	
    B_is_negetive:
	NEGF 0x11
	BTG 0x05, 0
	GOTO multi
	
    B_is_positive:
	GOTO multi
	
    multi:
	BTFSC 0x11, 0
	GOTO add
	GOTO right_shift
	
    add:
	MOVF 0x10, W
	ADDWF 0x20
	
    right_shift:
        RRCF 0x11
        BCF STATUS, 0
        RRCF 0x21
	BTFSC 0x20, 0
        BSF 0x21, 7
        BTFSS 0x20, 0
        BCF 0x21, 7
        BCF STATUS, 0
        RRCF 0x20
	
	DECFSZ 0x04
	GOTO multi
	
    last_check:
	BTFSS 0x05, 0
	GOTO finish
	NEGF 0x21
	COMF 0x20
	
    finish:
	MOVFF 0x20, 0x02
	MOVFF 0x21, 0x01
RETURN
