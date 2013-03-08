/*
 * Call this function to achieve White line following using sensors A3,A2,A1
 * Takes no input parameters
 * Returns void
 * Dependencies:
 * -->  MotorControl (int driveL, int driveR);
*/
void line_following ()
{
  if ((digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)))         // if all white // s3, s2, s1 on white
     MotorControl(1,1);
  else if ((digitalRead(Ls)) && (digitalRead(Ms)) && (!digitalRead(Rs)))    // if Right on black // S1 out
     MotorControl(0,1);
  else if ((digitalRead(Ls)) && (!digitalRead(Ms)) && (!digitalRead(Rs)))  // if Right & Middle on black // S1 & s2 out
     MotorControl(0,1);
  else if ((!digitalRead(Ls)) && (digitalRead(Ms)) && (digitalRead(Rs)))    // if Left on black // s2 out
     MotorControl(1,0);
  else if ((!digitalRead(Ls)) && (!digitalRead(Ms)) && (digitalRead(Rs)))  // if Left & Middle on black // S3 & s2 out
     MotorControl(1,0);
}

/*
 * Call this function to drive Motors of the Bot
 * Takes input parameters as: Left Drive Control and Right Drive Control
 * Returns void
 * Dependencies: none
*/
void MotorControl (int driveL, int driveR)
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

