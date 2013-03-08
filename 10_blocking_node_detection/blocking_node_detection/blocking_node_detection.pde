/*
 *  Program: Blocking Node Detection
 *  
 *  Reads an input from the grid solving sensors panel connected at pins A0,A1,A2,A3,A4
 *  Performs blocking node scan while grid traversing through the grid
 *  Node occurance is indicated by LED blink once. Blocking node is indicated by double LED blink
 *  Node information is stored onto the EEPROM
 *  EEPROM location once Written needs to be cleared manually
 *  The EEPROM Data can be used to later navigate the grid
 *  Background Color: White
 *  Line Color: White
 *  Sensor sequence -->  Sensor orientation: LED's facing forward
                         |----------------------------------------------|
                         |---A4----------A3-----A2-----A1----------A0---|
                         |----------------------------------------------|
                                      sensors utilised A4-A0
 
 *  Digital Sensor Output:  Black = 0
 *                          White = 1
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

#include <EEPROM.h>    // header file for EEPROM Functions

// Obstracle Sensor
#define obsSensor  3
// Switch Input
#define switchPin  2

// Grid Parameters
#define north  0
#define east   1
#define south  2
#define west   3

// Left Motor Controls
# define Lp  7    // ip B
# define Ln  4    // ip A
# define El  5    
// Right Motor Controls
# define Rp  8    // ip A
# define Rn  12   // ip B
# define Er  6

boolean blockingNode = false;
boolean homeStart = true;
boolean mappingComplete = false;
int nodeCount = 0;
int myDir = 0;

byte gridMap[] = {  0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0  };    // virtual Grid Mapping

void setup ()
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

  pinMode (A0, INPUT);  
  pinMode (A1, INPUT);
  pinMode (A2, INPUT);
  pinMode (A3, INPUT);
  pinMode (A4, INPUT);
  pinMode (switchPin, INPUT);
  pinMode (obsSensor, INPUT);
  
  // internally pullups are disabled in arduino firmware.
  // to use pullup, enable manually
  digitalWrite (obsSensor,HIGH);
  digitalWrite (switchPin,HIGH);

  // indication of code start
  for(int i=0; i<20; i++)
  {
    digitalWrite(13,LOW);
    delay(50);
    digitalWrite(13,HIGH);
    delay(50);
  }
  delay(2500);    // 2sec delay
  
  // press Switch to clear grid info // if pressed indicated with led blink
  if( !digitalRead(switchPin) )
  {
    for(int i=0; i<17; i++)
    {
      EEPROM.write(i, 0);
      digitalWrite(13,LOW);
      delay(50);
      digitalWrite(13,HIGH);
      delay(50);
    }
  }
  delay(2000);    // 2sec delay
  
  // wait for user to indicate start by momentarily triggering obstracle sensor
  while(!digitalRead(obsSensor));
  while(digitalRead(obsSensor));
}


void loop ()  {
// put your code here to run for ever

  if (EEPROM.read(0) == 0)
  {
    while( nodeCount<16)              // till all nodes are not discovered
    {
        if (homeStart)    nodeCount = 1;    // temporarily to enter the loop once
    
        if(nodeCount%4)               // if not column terminating node
        {
          if (homeStart)  { nodeCount = 0;  homeStart = false;  EEPROM.write(1, 1);}    // revert the temp change.
      
            digitalWrite(13,HIGH);    // indicate start line following
            while( (!digitalRead(A4)) || (!digitalRead(A0)) )
            {  line_following();  }    // do line following
            MotorControl(0,0);         //when the last sensors are on white stop
            digitalWrite(13,LOW);      // indicate stop line following
            
            if( (digitalRead(A4)) && (!digitalRead(A3)) && (!digitalRead(A2)) && (!digitalRead(A1)) && (digitalRead(A0)) )  // check for blocking node condition
            {
                delay(30);
                digitalWrite(13,HIGH);    // indicate start line following
                blockingNode = true;   // condition indicates a blocking node
                updateGridInfo();      // update node informtion
                while( (digitalRead(A4)) || (digitalRead(A0)) )    {  MotorControl(1,1);  }
                delay(50);
                digitalWrite(13,LOW);    // indicate start line following
            }
            else  
            {
                updateGridInfo();      // update node informtion
                while( (digitalRead(A4)) || (digitalRead(A0)) )    {  line_following();  }
            }
            MotorControl(0,0);    delay(350);    //when the last sensors are on black stop
        }
        
        else
        {
          changeColumn(nodeCount/4, myDir);      // span column
        }
    }
    // code below is executed when grid scanning is completed
    MotorControl(0,0);  delay(200);
    mappingComplete = true;  updateGridInfo();   // update node informtion
    
    if( (digitalRead(A4)) && (!digitalRead(A3)) && (!digitalRead(A2)) && (!digitalRead(A1)) && (digitalRead(A0)) )  // check for blocking node condition
    {
        while( (digitalRead(A4)) || (digitalRead(A0)) )    {  MotorControl(1,1);  }
        delay(50);
    }
    else  
    {
        while( (digitalRead(A4)) || (digitalRead(A0)) )    {  line_following();  }
    }
    MotorControl(1,1);	delay(150);
    homeRun(nodeCount-1, myDir);
    EEPROM.write(0, 1);
    while(1);
  }
  else
  {
      
      for(int i=0; i<17; i++)
      {
        Serial.print(EEPROM.read(i),DEC);
        digitalWrite(13,LOW);
        delay(30);
        digitalWrite(13,HIGH);
        delay(30);
      }
      while(1);
  }
}

/*
 * Call this function to update Grid Information for mapping
 * Takes no input parameters
 * Returns void
 * Dependencies: none
*/
void updateGridInfo ()
{
  if ( !mappingComplete )
  {
      if     (blockingNode)  { gridMap[nodeCount] = 2;  blockingNode = false;  }
      else   gridMap[nodeCount] = 1;
      nodeCount++;
  }
  /*
  else
  {
      int temp = 0;
      for(int i=1; i<17; i++)
      {
        if ( ((i-1)/4)%2 )
        {
            temp = (int)(((i-1)/4) * 4) + 4 - ((i-1)%4);
            EEPROM.write(temp, gridMap[i-1]);
        }
        else
        {
            EEPROM.write(i, gridMap[i-1]);
        }
        digitalWrite(13,HIGH);
        delay(30);
        digitalWrite(13,LOW);
        delay(30);
      }
  }
  */
  else
  {
      for(int i=1; i<5; i++)
      {
          EEPROM.write(i, gridMap[i-1]);
      }
      for(int i=8; i>4; i--)
      {
          EEPROM.write(i, gridMap[12-i]);
      }
      for(int i=9; i<13; i++)
      {
          EEPROM.write(i, gridMap[i-1]);
      }
      for(int i=16; i>12; i--)
      {
          EEPROM.write(i, gridMap[28-i]);
      }
        digitalWrite(13,HIGH);
        delay(50);
        digitalWrite(13,LOW);
        delay(50);
  }

}

