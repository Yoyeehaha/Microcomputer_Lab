#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

char str[20];
unsigned char received_char;
unsigned char num;

void InitializePorts() {
    TRISB = 0xF0;  
    LATB = 0x00;  
}

void SetLeds(unsigned char num) {
    LATB = (num & 0x0F);  
}

void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    
    SYSTEM_Initialize() ;
    InitializePorts();
    while(1) {
        strcpy(str, GetString()); // TODO : GetString() in uart.c
        if(str[0]=='m' && str[1]=='1'){ // Mode1
            Mode1();
            ClearBuffer();
        }
        else if(str[0]=='m' && str[1]=='2'){ // Mode2
            Mode2();
            ClearBuffer();  
        }
        SetLeds(num);  
        
    }
    return;
}

void __interrupt(high_priority) Hi_ISR(void)
{
    received_char = RCREG; 
                 
    UART_Write(received_char);
    UART_Write_Text('\0');

           
    if (received_char >= '0' && received_char <= '9') {
        num = received_char - '0';  
    }
}
