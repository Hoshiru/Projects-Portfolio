/*
 * LCD.h
 *
 * Created: 4/19/2014 4:46:59 PM
 *  Author: Jared
 *	A header file that includes basic LCD functions as well as ADC
 * and SPI functions.
 *
 *
 */ 

#include <avr/io.h>  
#include <util/delay.h> 

#define SS 2 
#define MOSI 3 
#define MISO 4
#define SCK 5 

#define LCD_DPRT	PORTB	//LCD DATA PORT
#define LCD_DDDR	DDRB	//LCD DATA DDR
#define LCD_DPIN	PINB	//LCD DATA PIN
#define LCD_CPRT	PORTB	//LCD COMMANDS PORT
#define LCD_CDDR	DDRB	//LCD COMMANDS DDR
#define LCD_CPIN	PINB	//LCD COMMANDS PIN
#define LCD_RS		0		//LCD RS
#define LCD_RW		1		//LCD RW
#define LCD_EN		2		//LCD EN

/*void ADCConvert(uint8_t *data){ 
    ADCSRA |= (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1);  	// ADC enable, ck/64 
    ADMUX |= (1 << REFS0) | (1 << REFS1) | (1 << ADLAR);    // 2.56 Vref, ADC0 single-ended, left-justified 
        
    ADCSRA |= (1 << ADSC);                                  // Start conversion 
    while ((ADCSRA & (1 << ADIF)) == 0);                  	// Wait for end of conversion 
        *data = ADCH; 
		*data = (*data)*5;									// Convert to degrees.  1 degree = 10mV
		*data = ((*data) - 0.5) * 100;
} */

void lcdCommands(unsigned char cmnd){
	LCD_DPRT = cmnd;				// send cmnd to data port
	LCD_CPRT &= ~(1<<LCD_RS);		// RS = 0 for command
	LCD_CPRT &= ~(1<<LCD_RW);		// RW = 0 for write
	LCD_CPRT |= (1<<LCD_EN);		// EN = 1 for H to L Pulse
	_delay_us(1);					// wait to make enable wide
	LCD_CPRT &= ~(1<<LCD_EN);		// EN = 0 for H-L Pulse
	_delay_us(100);					// wait to make enable wide
}

void lcdData(unsigned char data){
	LCD_DPRT = data;				// send data to data port
	LCD_CPRT |= (1<<LCD_RS);		// RS = 1 for data
	LCD_CPRT &= ~(1<<LCD_RW);		// RW = 0 for write
	LCD_CPRT |= (1<<LCD_EN);		// EN = 1 for H to L Pulse
	_delay_us(1);					// wait to make enable wide
	LCD_CPRT &= ~(1<<LCD_EN);		// EN = 0 for H-L Pulse
	_delay_us(100);					// wait to make enable wide
}

void lcd_init(){
	LCD_DDDR = 0xFF;				// data DDR as output
	LCD_CDDR = 0xFF;				// cmnd DDR as output
	
	LCD_CPRT &= ~(1<<LCD_EN);		//LCD_EN = 0
	_delay_us(2000);					//wait for init
	lcdCommands(0x38);				//inti. LCD 2 line, 5x7
	lcdCommands(0x0E);				//display on, cursor on
	lcdCommands(0x01);				//clear LCD
	_delay_us(2000);					//wait
	lcdCommands(0x06);				//shift cursor right
}

void lcd_setCursor(unsigned char x, unsigned char y){
	unsigned char firstCharAdr[] = {0x80, 0xC0, 0x94, 0xD4};		// array for start of each line on LCD
	lcdCommands(firstCharAdr[y] + x);								// y = LCD Line Select,  x = LCD line position
	_delay_us(100);
}

void lcd_print(char * str)
{
	unsigned char i = 0;
	while (str[i]!=0)				// while string entry is not 0 or NULL
	{
		lcdData(str[i]);			// display char in string entry
		i++;						// increment to next char
	}
}

/*void readDataSPI(char data){
    DDRB |= (1<<2)|(1<<3)|(1<<5);    // SS, MOSI and SCK as outputs
    DDRB &= ~(1<<4);                 // MISO as input

    SPCR |= (1<<MSTR);               // Set as Master
    SPCR |= (1<<SPR0)|(1<<SPR1);     // divided clock by 128
    SPCR |= (1<<SPE);                // Enable SPI
    
    while(1)
    {
        SPDR = data;                 // send the data
        while(!(SPSR & (1<<SPIF)));  // wait until transmission is complete
    }
}

void sendDataSPI(char data){
    DDRB &= ~((1<<2)|(1<<3)|(1<<5));   // SS, MOSI and SCK as outputs
    DDRB |= (1<<4);                    // MISO as output

    SPCR &= ~(1<<MSTR);                // Set as slave 
    SPCR |= (1<<SPR0)|(1<<SPR1);       // divide clock by 128
    SPCR |= (1<<SPE);                  // Enable SPI

    while(1)
    {
        while(!(SPSR & (1<<SPIF)));    // wait until all data is received
        data = SPDR;                   // we now have our data
    }
}
*/