/*
 *  Program: line_following_black
 *  
 *  Reads an input from the line following sensors panel connected at pins A1,A2,A3
 *  and drives the left and right motor to trace the line 
 *  Background Color: White
 *  Line Color: Black
 *  Sensor sequence -->  Sensor orientation: LED's facing forward
                         |----------------------------------------------|
                         |---A4----------A3-----A2-----A1----------A0---|
                         |----------------------------------------------|
                                      sensors utilised A3-A1
 *  
 *  Digital Sensor Output:  Black = 0
 *                          White = 1
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

// Left Motor Controls
# define Lp  7    // ip B
# define Ln  4    // ip A
# define El  5
// Right Motor Controls
# define Rp  8    // ip A
# define Rn  12   // ip B
# define Er  6
// Grid Sensors // holding the bot with gripper oriented outwards
# define Rs   A1
# define Ms   A2
# define Ls   A3

void setup()
{  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode (Lp, OUTPUT);
  pinMode (Ln, OUTPUT);
  pinMode (El, OUTPUT);
  pinMode (Rp, OUTPUT);
  pinMode (Rn, OUTPUT);
  pinMode (Er, OUTPUT);
  
  digitalWrite (El,HIGH);
  digitalWrite (Er,HIGH);
  
  pinMode (Rs, INPUT);    // A1
  pinMode (Ms, INPUT);    // A2
  pinMode (Ls, INPUT);    // A3
}

void loop()  {
// put your code here to run for ever
  if ((!digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)))       // if all black
     {  MotorControl(1,1); Serial.println("forward");   }
  else if ((digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)))    // if left on white // S3 out
     {  MotorControl(1,0); Serial.println("right"); }
  else if ((digitalRead(Ls)) && (digitalRead(Ms)) && (!digitalRead(Rs)))    // if left & middle on white // S3 & s2 out
     {  MotorControl(1,0); Serial.println("right sharp"); }
  else if ((!digitalRead(Ls)) && (!digitalRead(Ms)) && (digitalRead(Rs)))    // if right on white // s1 out
     {  MotorControl(0,1); Serial.println("left"); }
  else if ((!digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)))    // if right & middle on white // S2 & s1 out
     {  MotorControl(0,1); Serial.println("left sharp"); }
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

