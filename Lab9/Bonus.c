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

void PWM_init(void);
void ADC_init(void);

unsigned int adc_val;
unsigned int duty_cycle;

void main(void) 
{
    PWM_init();
    ADC_init();
    
    while(1){
        ADCON0bits.GO = 1; // Start ADC conversion
        while (ADCON0bits.GO_nDONE); // Wait for conversion to complete
        adc_val = ADRESH; // Return 8-bit result
        
        if (adc_val <= 128) {
            duty_cycle = adc_val * 8;   //128 -> 1024
        } else {
            duty_cycle = (255 - adc_val) * 8;
        }
        
        // Update PWM duty cycle
        CCPR1L = (duty_cycle >> 2);      // Top 8 bits
        CCP1CONbits.DC1B = duty_cycle & 0x03; // Bottom 2 bits
    }
    return;
}

void PWM_init(){
    TRISCbits.RC2 = 0;       // Set RC2/CCP1 as output
    PR2 = 255;               // PWM period (1 ms at 1 MHz with prescaler = 4)
    T2CONbits.T2CKPS = 0b01; // Timer2 prescaler = 4
    CCP1CONbits.CCP1M = 0b1100; // PWM mode
    T2CONbits.TMR2ON = 1;    // Enable Timer2
}

void ADC_init(){
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
    ADCON0bits.CHS = 0;      // Select AN0
}
