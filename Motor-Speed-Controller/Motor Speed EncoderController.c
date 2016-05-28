/*  
 * Motor Speed Encoder and Controller.c 
 *  
 * Created: 5/8/2014 2:03:40 PM  
 *  Author: Jared Hayes 
 *   
 *   C program to control DC motor speed and direction using PWM signals, PID control, and an optical 
 * encoder. By default, the motor will run clockwise gradually increasing speed from 0% to 100%, wait,  
 * and then do the same thing in the counter-clockwise direction using PWM.  When a switch is activated, 
 * an interrupt will cause the motor to change to PID control in order to turn 90 degrees at a time for 
 * a full rotation in a given direction and then reverse directions.  The optical encoder will keep track 
 * of the motor's direction and position through two signals that are 90 degrees out of phase. 
 * 
 * 
 */ 
  
 #define F_CPU 8000000UL 
#include <avr/io.h>  
#include <util/delay.h> 
#include <avr/interrupt.h> 
#include "LCD.h" 
  
#define led1            3                   // SigA led                     -PC3-       
#define led2            4                   // SigB led                     -PC4-
#define motorPin1       4                   // Motor Pin +                  -PD4- 
#define motorPin2       5                   // Motor Pin -                  -PD5- 
#define pwm             6                   // PWM for motor speed          -PD6-
#define sw              7                   // Switch/Button                -PD7- 
#define CMD_ANALOGWRITE 11

int sigA = 0;								// Encoder Signal A, int0       -PD2-
int sigB = 0;								// Encoder Signal B, int1       -PD3-

int ard_command = 0;
int pin_num = 0;
int pin_value = 0;
char get_char = ' ';  //read serial
    
volatile int CurrentPosition = 0; 
volatile int DesiredPosition = 0; 

//========================================== Motor Control ================================================== 
    
void cw(void){ 
    PORTD |= (1<<motorPin1);              				// Motor Pin + turned high 
    PORTD &= ~(1<<motorPin2);             				// Motor Pin - turned low 
    lcd_setCursor(13,0);								// Row 1, Column 14
    lcd_print("   ");									// Clear
    lcd_setCursor(13,0); 
    lcd_print("CW"); 
} 
    
void ccw(void){ 
    PORTD |= (1<<motorPin2);              				// Motor Pin - turned high 
    PORTD &= ~(1<<motorPin1);            				// Motor Pin + turned low 
    lcd_setCursor(13,0);								// Row 1, Column 14
    lcd_print("   ");
    lcd_setCursor(13,0); 
    lcd_print("CCW"); 
} 
    
void brake(void){ 
    PORTD &= ~(1<<motorPin1);             				// Motor Pin + turned low 
    PORTD &= ~(1<<motorPin2);             				// Motor Pin - turned low 
} 

int dutyConvert(int x, int in_min, int in_max, int out_min, int out_max)
{
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;		// Convert to Duty Cycle
}

void DisplayPosition(char count)
{
	char x, y; 											// Display current position
	for(x=0; x<count; x++)
	{
		lcd_setCursor(4,1);                    			// Set cursor to Row 2, Column 4
		lcdData(CurrentPosition);           			// Displaying current position on LCD
		for(y=0; y<50; y++);             				// Time delay
	}
}
    
void setSpeed(){
	uint8_t dutyCycle;                    				// Set OCR0A to desired motor speed connected to En on H-bridge 
	for (int i = 0; i < 256; i++)						// Increment motor speed from 0-255
	{
		cw();											// Turn Motor clockwise
		OCR0A = i;										// OC0RA = speed
		//dutyCycle = i/256; 
		//dutyCycle = dutyCycle*100; 
		dutyCycle = dutyConvert(i, 0, 255, 0, 100);		// Convert speed to duty cycle
   
		lcd_setCursor(13,1); 							// Column 14, Row 2
		lcd_print("   "); 								// Clear
		lcd_setCursor(13,1); 							// Column 14, Row 2
		lcdData(dutyCycle); 							// Display duty cycle to lcd
		_delay_ms(50);									
	}

	_delay_ms(3000);									// Wait 3 seconds
	PORTD &= ~(1<<motorPin1);             				// Motor Pin + turned low ==> Motor off
	DisplayPosition(1); 								// Display current position
  
	for (int i = 0; i < 256; i++)						// Increment motor speed from 0-255
	{
		ccw();											// Turn Motor counter-clockwise
		OCR0A = i;										// OCR0A = speed
		dutyCycle = dutyConvert(i, 0, 255, 0, 100);		// Convert speed to duty cycle
		//dutyCycle = i/256; 
		//dutyCycle = dutyCycle*100; 
    
		lcd_setCursor(13,1); 							// Column 14, Row 2
		lcd_print("   "); 								// Clear
		lcd_setCursor(13,1); 							// Column 14, Row 2
		lcdData(dutyCycle); 							// Display duty cycle to lcd
		_delay_ms(50);
	}

	_delay_ms(3000);									// Wait 3 seconds
	PORTD &= ~(1<<motorPin2);          				   	// Motor Pin - turned low ==> Motor off 
	DisplayPosition(1); 
}

//=========================================== Calculations / Bluetooth =====================================

void setup(){
	DDRD |= (1<<motorPin1) | (1<<motorPin2) | (1<<pwm);  // Define PortD I/O
}
    
void uart_init()
{
    UBRR0H = (((F_CPU/9600/16)-1) >> 8);
    UBRR0L = ((F_CPU/9600/16)-1);
    UCSR0C = (3 << UCSZ00);
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);
}

uint8_t uart_char_is_waiting() {
    // returns 1 if a character is waiting
    // returns 0 if not
    return (UCSR0A & (1<<RXC0));
}

char uart_read() {
    // wait
    while(!uart_char_is_waiting());
    char x = UDR0;
    return x;
}

void blueTooth(void){
    // parse incoming command start flag 
    get_char = uart_read();
        
    // parse incoming command type
    ard_command = uart_read(); // read the command
  
    // parse incoming pin# and value  
    pin_num = uart_read(); // read the pin
    pin_value = uart_read();  // read the value 
 
   // 3) GET analogWrite DATA FROM ARDUDROID
    if (ard_command == CMD_ANALOGWRITE) {  
      OCR0A = pin_value; 
      return;  // Done. return to loop();
    }   
}	
    
//============================================ Main Function ================================================ 
    
int main(void) 
{ 
    setup();
    DDRB = 0xFF;                                                    // Port B as output 
    DDRC = 0xFF;                                                    // Port C as output 
    DDRD |= (1<<motorPin1) | (1<<motorPin2) | (1<<pwm);             // Define PortD I/O
    PORTB = 0;														// Clear Port B and C
    PORTC = 0;                                                     
    PIND = (1<<2) | (1<<3);											// Read int0/int1 inputs (PD2/PD3)
    lcd_init();														// Initialize LCD
        
// ----Enable PWM on OC0A---- 
    TCCR0A |= ( 1 << COM0A1 ) | ( 1 << WGM01 ) | ( 1 << WGM00 );   // Fast PWM - PD6 to Enable on H-bridge 
    TCCR0B |= (1<<CS01) | (1<<CS00);            						// 64 Prescaler         
        
// ----Set INT0/INT1 for Encoder signals---- 
    EIMSK |= (1<<INT1) | (1<<INT0);                                // Enable int0/int1 interrupts 
    EICRA |= (1<<ISC11) | (1<<ISC10) | (1<<ISC01) | (1<<ISC00);    // Trigger on rising edge 
        
// ----Configure LCD---- 											
    lcd_setCursor(0,0); 											// Column 1, Row 1
    lcd_print("Motor: Turn= "); 									
    lcd_setCursor(0,1); 											// Column 1, Row 2
    lcd_print("Pos="); 
    lcd_setCursor(9,1); 											// Column 10, Row 2
    lcd_print("Spd="); 
    sei(); 															// Enable interrupts
        
    while(1) 
    { 
		blueTooth();
        setSpeed();      											// Increment motor speed
    } 
} 
    
//========================================== Encoder Control ============================================== 
    
ISR(INT0_vect){                              
	sigA ^= 1;								// Signal A Rising Edge
    PORTC ^= (1<<led1);                       // Toggle led1
      
    if(sigB == 0)							// If Signal B is low... 
        CurrentPosition++;                  // moving forward 
    if(sigB == 1)							// If Signal B is high... 
        CurrentPosition--;                  // moving reverse 
} 
    
ISR(INT1_vect){                              
	sigB ^= 1;								// Signal B Rising Edge
    PORTC ^= (1<<led2);                     	// Toggle led2
      
    if(sigA == 1)							// If Signal A is high.. 
        CurrentPosition++;                  // moving forward 
    if(sigA == 0)							// If Signal A is low... 
        CurrentPosition--;                  // moving reverse 
}
    
//================================== PID Motor Control 90 degree turns ==================================== 
    
ISR(PCINT1_vect){                                             // Push Button/Switch pressed 
	pidEnable = 1;
    int Output, Error0, ErrorDifferent;  
    static int Error1, Error2, Error3, Sum_E; 
        
    // Timer1 100Hz                                         // Motor PID control (sample rate = 100Hz) 
    Error0 = DesiredPosition - CurrentPosition;             // Counting current error 
        
    if(Error0>150)                                           // Motor run full speed if current position is too far from desire position 
    { 
        ccw();                                              // Counter-clockwise turn for positive error     
        setSpeed(255);                                      // Full speed 
        Sum_E=0;                                            // Clear summing error 
    } 
    else if(Error0<-150)                                 // Motor run full speed if current position is too far from desire position 
    { 
        cw();                                               // Clockwise turn for negative error 
        setSpeed(255);                                      // Full speed 
        Sum_E=0;                                            // Clear summing error 
    }            
    else                                                    // Motor PID control when nearly to desire position 
    {            
    // -----Integral term---- 
        Sum_E+=Error0;                                      // Summing error (Integral term) 
        if(Sum_E>240) Sum_E=240;                         // Limit summing error 
        else if(Sum_E<-240) Sum_E=-240;                      // Limit summing error 
        if((Error0>-2)&&(Error0<2)) Sum_E=0;              // Clear summing error to reduce the oscillation 
            
    // ----Derivative term---- 
        ErrorDifferent = Error0 - Error3;                   // Error different between current error and last third error  
            
    // ----PID output----- 
        Output = (Error0*4) + (Sum_E) + (ErrorDifferent*22);    // Output = Proportional term + Integral term + Derivative term 
            
    // ----Motor PID control---- 
        if(Output>1) 
        { 
            ccw();                                          // Counter-clockwise turn for positive error 
            if(Output>255) Output=255;                       // Limit maximum output speed 
            else if(Output<140) Output=140;                  // Mininum output for motor dead zone 
            setSpeed(Output);                               // Motor speed proportional to PID output 
        } 
        else if(Output<-1) 
        { 
            cw();                                           // Clockwise turn for negative error 
            Output=(-Output);                               // Modulus for negative output 
            if(Output>255) Output=255;                       // Limit maximum output speed 
            else if(Output<140) Output=140;                  // Mininum output for motor dead zone 
            setSpeed(Output);                               // Motor speed proportional to PID output 
        } 
        else brake();                                       // Brake the motor if desire position reached 
            
        // Previous errors saving for next Derivative term counting use  
        Error3 = Error2; 
        Error2 = Error1; 
        Error1 = Error0;     
    }            
}

 
 