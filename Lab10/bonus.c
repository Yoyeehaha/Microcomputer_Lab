#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;
#define _XTAL_FREQ 4000000

char str[20];
unsigned char i;
unsigned char received_char;
unsigned char num;
unsigned char num_before;
unsigned char isRunning = 1;

void InitializePorts() {
    TRISB = 0xF0;  
    LATB = 0x00;  
    TRISAbits.TRISA1 = 1; 
    LATA = 0;
    return;
}

void SetLeds(unsigned char num) {
    LATB = (num & 0x0F);  
    return;
}

void Mode1(){   // Todo : Mode1 
    return ;
}
void Mode2(){   // Todo : Mode2 
    return ;
}
void main(void) 
{
    i = 0;
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
        
        if ((num_before != num) && isRunning){
            i = 0;
        } 

        if ((i <= num) && isRunning) {
            num_before = num;
            SetLeds(i);
            __delay_ms(500);
            i = (i + 1) % (num + 1);
        }     
        
       
        if(PORTAbits.RA1 == 0){
            isRunning = 0; 
            __delay_ms(50);
        }
        
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
    return;
}
 
