/*
 *  Program: motor_on_off_serial___RF
 *  
 *  Reads an input Serial Port and drives the Bot
 *  Program demonstrates manual control of Robot drive
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

// LED for indication
#define ledPin  13
// Left Motor Controls
# define Lp  7    // ip A
# define Ln  4    // ip B
# define El  5    
// Right Motor Controls
# define Rp  8   // ip A
# define Rn  12  // ip B
# define Er  6

byte serialByte;         // incoming serial byte

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode (ledPin, OUTPUT);
  pinMode (Lp, OUTPUT);
  pinMode (Ln, OUTPUT);
  pinMode (El, OUTPUT);
  pinMode (Rp, OUTPUT);
  pinMode (Rn, OUTPUT);
  pinMode (Er, OUTPUT);
  
  digitalWrite (ledPin,LOW);
  digitalWrite (El,HIGH);
  digitalWrite (Er,HIGH);
}

void loop() {

  if (Serial.available())
  {
      serialByte = Serial.read();
  }

  botControl(serialByte);
}

void botControl(int drive)
{
switch (drive) {
    case 'w':                  // go forward
      digitalWrite (Lp,LOW);
      digitalWrite (Ln,HIGH);
      digitalWrite (Rp,LOW);
      digitalWrite (Rn,HIGH);
      break;
    case 's':                  // go backward
      digitalWrite (Lp,HIGH);
      digitalWrite (Ln,LOW);
      digitalWrite (Rp,HIGH);
      digitalWrite (Rn,LOW);
      break;
    case 'a':                  // go left
      digitalWrite (Lp,HIGH);
      digitalWrite (Ln,LOW);
      digitalWrite (Rp,LOW);
      digitalWrite (Rn,HIGH);
      break;
    case 'd':                  // go right
      digitalWrite (Lp,LOW);
      digitalWrite (Ln,HIGH);
      digitalWrite (Rp,HIGH);
      digitalWrite (Rn,LOW);
      break;
    case 'x':                  // stop
      digitalWrite (Lp,LOW);
      digitalWrite (Ln,LOW);
      digitalWrite (Rp,LOW);
      digitalWrite (Rn,LOW);
      break;
    default: break;           // no action
  }
}
