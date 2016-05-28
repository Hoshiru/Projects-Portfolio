/*
 * Design_Assignment_7.c
 *
 * Created: 4/19/2014 4:46:59 PM
 *  Author: Jared
 *	Write a C AVR program that will monitor the LM34/LM35 connected to an Analog pin
 * to display the temperature in C or F on the Nokia 5110 GLCD display.
 *
 *
 */ 

#define F_CPU 8000000UL 
#include <avr/io.h>  
#include <util/delay.h> 
#include "fonts.h"

#define SCE 			2 					// Chip Enable (active low) 	-PD2-
#define RST				3 					// Reset (active low)			-PD3-
#define DC 				4					// Data(high) / Command(low)	-PD4-
#define DIN				MOSI				// Serial Data In				-PB3-
#define SCLK			SCK					// Serial Clock in				-PB5-

#define MOSI			3					// PB3
#define SS				2					// PB2							
#define SCK				5					// PB5

/*-----------------------------------SPI Transfer----------------------------------*/
void SPI_execute(uint8_t data){
	DDRB = (1 << MOSI) | (1 << SCK) | (1 << SS);          	// MOSI and SCK are output
	SPCR = (1 << SPE) | (1 << MSTR) | (1 << SPR0);          // enable SPI as master

	PORTB &= (1 << SS);                                     // initializing packet, pull SS low
	
	SPDR = data;                                            // start data transmission
	while (!(SPSR & (1 << SPIF)));                          // wait transfer finish
	
	PORTB |= (1 << SS);                                     // terminate packet, pull SS high
}

/*----------------------------------LCD Functions----------------------------------*/
void LcdWriteCmd(unsigned char cmd)
{
	PORTD &= ~(1<<DC); 						// DC pin is low for commands
	PORTD &= ~(1<<SCE);						// Chip enable (low)
	SPI_execute(cmd); 						// Transmit serial data
	PORTD |= (1<<SCE);						// Chip disable (high)
}

void LcdWriteData(unsigned char data)
{
	PORTD |= (1<<DC); 						// DC pin is high for data
	PORTD &= ~(1<<SCE);						// Chip enable (low)
	SPI_execute(data); 						// Transmit serial data
	PORTD |= (1<<SCE);						// Chip disable (high)
}

void LcdWriteCharacter(unsigned char character)
{
	for(int i=0; i<5; i++) 							// 5 char bytes per ASCII character
		LcdWriteData(ASCII[character - 0x20][i]);
	LcdWriteData(0x00);								//  Add space after to make the letter 6 bytes long
}													// 84 columns is divisible by 6, so letters are not
													// split at the end of a row.
void lcd_print(char *str)
{
	unsigned char i = 0;
	while (str[i]!=0)						// while string entry is not 0 or NULL
	{
		LcdWriteCharacter(str[i]);			// display char in string entry
		i++;								// increment to next char
		//LcdWriteCharacter(*str++);
	}
}

void ClearLCD()
{
	for(int i=0; i<504; i++) 				// 84 columns x 6 rows in bytes = 504 bytes to clear
	LcdWriteData(0x00); 					// clear LCD
}

void lcd_gotoxy(unsigned char x, unsigned char y)
{
	LcdWriteCmd(0x80 | x);  				// Column - 7th bit set to 1 OR'd with desired column #
	LcdWriteCmd(0x40 | y); 					// Row - 6th bit set to 1 OR'd with desired row #
}

void setup()
{
	DDRD |= (1<<SCE) | (1<<RST) | (1<<DC);	// Set SCE, RST, DC to output
	DDRB |= (1<<DIN) | (1<<SCLK);  			// Set DIN and SCLK to output
	PORTD &= ~(1<<RST);						// Send low pulse to Reset display				
	PORTD |= (1<<RST);						// Send high pulse to Reset display			
 	
	LcdWriteCmd(0x21); 						// LCD extended commands
	LcdWriteCmd(0xB8); 						// set LCD Vop (contrast)
	LcdWriteCmd(0x04); 						// set temp coefficent
	LcdWriteCmd(0x14); 						// LCD bias mode 1:40
	LcdWriteCmd(0x20); 						// LCD basic commands
	LcdWriteCmd(0x0C); 						// LCD normal video
}

/*------------------Analog to Digital Converter / Temp Calculation-----------------*/
void ADCConvert(uint8_t *data){ 
    ADCSRA |= (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1);  	// ADC enable, ck/64 
    ADMUX |= (1 << REFS0) | (1 << REFS1) | (1 << ADLAR);    // 2.56 Vref, ADC0 single-ended, left-justified 
        
    ADCSRA |= (1 << ADSC);                                  // Start conversion 
    while ((ADCSRA & (1 << ADIF)) == 0)                 	// Wait for end of conversion 
	{
        *data = ADCH; 
		*data = (*data)*5;									// Convert to degrees.  1 degree = 10mV
		*data = ((*data) - 0.5) * 100;
		//*data = ((*data) * 9.0 / 5.0) + 32.0;				// Convert to fahrenheit
	}
} 

/*--------------------------------------Main Function-------------------------------*/
int main(void)
{
	uint8_t temp = 0;               		// Value to hold the temperature 			
    DDRC = 0;                               // Port C set as input for ADC 
	setup();								// Initialize LCD display
	
    while(1)
    {
        ADCConvert(&temp);					// Convert voltage f/ temp sensor in PC0 to temp
		ClearLCD();
		lcd_gotoxy(1,1);					// Set LCD cursor to the start of first line
		lcd_print(" Temperature = ");		// Display string
		LcdWriteData(temp);					// Display Temperature
		lcd_print(" degrees C ");			// Display string
    }
}






