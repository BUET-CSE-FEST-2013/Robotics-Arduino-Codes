/*
 *  Program: line_following_white
 *  
 *  Reads an input from the line following sensors panel connected at pins A1,A2,A3
 *  and drives the left and right motor to trace the line 
 *  Background Color: Black
 *  Line Color: White
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
  
  pinMode (Rs, INPUT);
  pinMode (Ms, INPUT);
  pinMode (Ls, INPUT);
}
  
void loop()  {
// put your code here to run for ever
  if ((digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)))         // if all white // s3, s2, s1 on white
     {  MotorControl(1,1); Serial.println("forward");   }
  else if ((digitalRead(Ls)) && (digitalRead(Ms)) && (!digitalRead(Rs)))    // if Right on black // S1 out
     {  MotorControl(0,1); Serial.println("left"); }
  else if ((digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)))  // if Right & Middle on black // S1 & s2 out
     {  MotorControl(0,1); Serial.println("left sharp"); }
  else if ((!digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)))    // if Left on black // s2 out
     {  MotorControl(1,0); Serial.println("right"); }
  else if ((!digitalRead(Ls)) && (!digitalRead(Ms)) && (digitalRead(Rs)))  // if Left & Middle on black // S3 & s2 out
     {  MotorControl(1,0); Serial.println("right sharp"); }
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

