#include <xc.h>
#include <pic18f4520.h>

#pragma config OSC = INTIO67    // Oscillator Selection bits
#pragma config WDT = OFF        // Watchdog Timer Enable bit 
#pragma config PWRT = OFF       // Power-up Enable bit
#pragma config BOREN = ON       // Brown-out Reset Enable bit
#pragma config PBADEN = OFF     // Watchdog Timer Enable bit 
#pragma config LVP = OFF        // Low Voltage (single -supply) In-Circute Serial Pragramming Enable bit
#pragma config CPD = OFF        // Data EEPROM?Memory Code Protection bit (Data EEPROM code protection off)

#define BUTTON PORTBbits.RB0
#define DELAY 50 
#define _XTAL_FREQ 125000 

#define NEG_90 0x03 
#define POS_90 0x12

volatile unsigned char state = 0;

void rotate(void)
{
    for (int CCPRL = NEG_90; CCPRL <= POS_90; CCPRL++){
        for (int CCPCON = 0b00; CCPCON <= 0b11; CCPCON++){
            CCPR1L = CCPRL;  
            CCP1CONbits.DC1B = CCPCON;
            __delay_ms(750);
        }       
    }
}

void main(void)
{
     // Timer2 -> On, prescaler -> 4
    T2CONbits.TMR2ON = 0b1;
    T2CONbits.T2CKPS = 0b01;

    // Internal Oscillator Frequency, Fosc = 125 kHz, Tosc = 8 µs
    OSCCONbits.IRCF = 0b001;
    // PWM mode, P1A, P1C active-high; P1B, P1D active-high
    CCP1CONbits.CCP1M = 0b1100;
    // CCP1/RC2 -> Output
    TRISC = 0;
    LATC = 0;
    // Set up PR2, CCP to decide PWM period and Duty Cycle
    /** 
     * PWM period
     * = (PR2 + 1) * 4 * Tosc * (TMR2 prescaler)
     * = (0x9b + 1) * 4 * 8µs * 4
     * = 0.019968s ~= 20ms
     */
    PR2 = 0x9b;
    /**
     * Duty cycle
     * = (CCPR1L:CCP1CON<5:4>) * Tosc * (TMR2 prescaler)
     * = (0x0b*4 + 0b01) * 8µs * 4
     * = 0.00144s ~= 1450µs
     */
    CCPR1L = NEG_90;  //init set -90
    CCP1CONbits.DC1B = 0b00;
    
    TRISBbits.TRISB0 = 1;
    while (1) { 
        if (!BUTTON && (state == 0)) {
            __delay_ms(50); // Debounce delay
            if (CCPR1L != POS_90) {
                rotate(); 
                CCPR1L = NEG_90;
                CCP1CONbits.DC1B = 0b00;
            }
            state = 1;
        } else if (state == 1){
            if (CCPR1L != POS_90) {
                rotate(); 
                CCPR1L = NEG_90;
                CCP1CONbits.DC1B = 0b00;
                //__delay_ms(750);
            }
        }
    }
    return;
}
