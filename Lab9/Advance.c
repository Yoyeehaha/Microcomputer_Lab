#include <xc.h>
#include <pic18f4520.h>
#include <stdio.h>

#pragma config OSC = INTIO67 // Oscillator Selection bits
#pragma config WDT = OFF     // Watchdog Timer Enable bit
#pragma config PWRT = OFF    // Power-up Enable bit
#pragma config BOREN = ON    // Brown-out Reset Enable bit
#pragma config PBADEN = OFF  // Watchdog Timer Enable bit
#pragma config LVP = OFF     // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF     // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

#define _XTAL_FREQ 125000 

void display_number(unsigned char number);
int last_value = 0;

void __interrupt(high_priority)H_ISR(){
    
    //step4
    int value = ADRESH;
    
    //do things
    int state = __awdiv(value, 32);  //means value / 32;
    
    if (value > last_value) {
        
        switch(state){
            case 0:
                display_number(1);
                break;
            case 1:
                display_number(3);
                break;
            case 2:
                display_number(5);
                break;
            case 3:
                display_number(7);
                break;
            case 4:
                display_number(9);
                break;
            case 5:
                display_number(11);
                break;
            case 6:
                display_number(13);
                break;
            case 7:
                display_number(15);
                break;
            default:            
                break;
        }
    } else {
        switch(state){
            case 0:
                display_number(0);
                break;
            case 1:
                display_number(2);
                break;
            case 2:
                display_number(4);
                break;
            case 3:
                display_number(6);
                break;
            case 4:
                display_number(8);
                break;
            case 5:
                display_number(10);
                break;
            case 6:
                display_number(12);
                break;
            case 7:
                display_number(14);
                break;
            default:            
                break;
        }
    }
    
    if (abs(value - last_value) > 10) {  //prevent 15 turn into 14
        last_value = value;
    }
    
    
    //clear flag bit
    PIR1bits.ADIF = 0;
    
    
    //step5 & go back step3
    __delay_ms(700);
    //delay at least 2tad
    ADCON0bits.GO = 1;
    
    
    return;
}

void main(void) 
{
    //configure OSC and port
    OSCCONbits.IRCF = 0b100; //1MHz
    TRISAbits.RA0 = 1;       //analog input port
    
    //step1
    ADCON1bits.VCFG0 = 0;
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.PCFG = 0b1110; //AN0 ?analog input,???? digital
    ADCON0bits.CHS = 0b0000;  //AN0 ?? analog input
    ADCON2bits.ADCS = 0b000;  //????000(1Mhz < 2.86Mhz)
    ADCON2bits.ACQT = 0b001;  //Tad = 2 us acquisition time?2Tad = 4 > 2.4
    ADCON0bits.ADON = 1;
    ADCON2bits.ADFM = 0;    //left justified 
    TRISB = 0xF0;
    
    //step2
    PIE1bits.ADIE = 1;
    PIR1bits.ADIF = 0;
    INTCONbits.PEIE = 1;
    INTCONbits.GIE = 1;


    //step3
    ADCON0bits.GO = 1;
    
    while(1);
    
    return;
}

void display_number(unsigned char number) {
    LATB = (LATB & 0xF0) | (number & 0x0F); // Set RB0-RB3
}

