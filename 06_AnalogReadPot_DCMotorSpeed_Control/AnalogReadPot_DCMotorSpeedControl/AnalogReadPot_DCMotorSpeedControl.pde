/*
*  Program: AnalogReadPot_DCMotorSpeed_Control
*
*  Reads an analog input on pin 5 connected to the potentiometer and prints the result to the serial monitor
*  Further, applies this analog input to generate PWM for left and Right motor.
*  Potentiometer value: 10K
***********  max and min resistance voltage values to be measured and added here
*  Reference Voltage: 5V
*  Resolution of ADC: 10 bit
*  Conversion: (5/1024) * 10000
*              thus,       1 ADC count ~ 48.87 ohms
*  Map the potentiometer input to PWM speed input for DC Motor
*  Map Range: -127 to +127
*  DC Motor Base Speed: 128
*  Author: Robosoft Systems for Nexus Workshop
*/

// Potentiometer Input
# define PotPinNo  A5
// Left Motor Controls
# define Lp  7    // ip B
# define Ln  4    // ip A
# define El  5    
// Right Motor Controls
# define Rp  8    // ip A
# define Rn  12   // ip B
# define Er  6

#define BaseSpeed 128
int PotDATA = 0;    // variable to store the pot position 

void setup()
{ // put your setup code here, to run once:
  analogReference(EXTERNAL);    // define reference voltage as internal 2.56V
  Serial.begin(9600);           // serial communication baud rate
  
  pinMode (Lp, OUTPUT);
  pinMode (Ln, OUTPUT);
  pinMode (El, OUTPUT);
  pinMode (Rp, OUTPUT);
  pinMode (Rn, OUTPUT);
  pinMode (Er, OUTPUT);

  digitalWrite (El,LOW);
  digitalWrite (Er,LOW);
  MotorControl(1,1);
}

void loop()  {
  PotDATA = analogRead(PotPinNo);    // perform analog reading on the defined pin and store value to analogPinData
  Serial.print("Potentiometer reading: ");    // Inditate what data is being displayed
  Serial.print(PotDATA*48.87, DEC);         // output the value of potentiometer on to serial port
  Serial.println(" ohms");
  
  int pwm = map(PotDATA,0,1023,-127,127);    // map the ADC range of 0-1023 to
                                             // Motor PWM range of -127 to +127
  analogWrite( El, BaseSpeed+pwm );        // Add PWM input
  analogWrite( Er, BaseSpeed-pwm );        // Subtract PWM input
}

void MotorControl(int driveL, int driveR)
{
switch (driveL) {
      
    case 0:                  // lft STOP
      digitalWrite (Ln,LOW);
      digitalWrite (Lp,LOW);
      break;
      
    case 1:                  // lft FORWARD
      digitalWrite (Ln,HIGH);
      digitalWrite (Lp,LOW);
      break;
      
    case 2:                  // lft REVERSE
      digitalWrite (Ln,LOW);
      digitalWrite (Lp,HIGH);
      break;
      
    default:break;
  } 
  
switch (driveR) {
      
    case 0:                  // rgt STOP
      digitalWrite (Rn,LOW);
      digitalWrite (Rp,LOW);
      break;
      
    case 1:                  // rgt FORWARD
      digitalWrite (Rn,HIGH);
      digitalWrite (Rp,LOW);
      break;
      
    case 2:                  // rgt REVERSE
      digitalWrite (Rn,LOW);
      digitalWrite (Rp,HIGH);
      break;
      
    default:break;
  }
}

