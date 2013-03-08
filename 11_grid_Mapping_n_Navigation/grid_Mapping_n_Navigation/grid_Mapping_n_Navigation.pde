/*
 *  Program: Grid Mapping and Navigation
 *  
 *  Reads an input from the grid solving sensors panel connected at pins A0,A1,A2,A3,A4
 *  Performs blocking node scan while grid traversing through the grid
 *  Node occurance is indicated by LED blink once. Blocking node is indicated by double LED blink
 *  Node information is stored onto the EEPROM
 *  EEPROM location once Written needs to be cleared manually
 *  The EEPROM Data is further used for Grid navigation to perform Rescue Run
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

// LED for indication
#define ledPin  13
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
// Grid Sensors // 
# define ERs  A0
# define Rs   A1
# define Ms   A2
# define Ls   A3
# define ELs  A4

boolean blockingNode = false;
boolean homeStart = true;
boolean mappingComplete = false;
int nodeCount = 0;
int myDir = 0;

byte gridMap[] = {  0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0,
                    0, 0, 0, 0  };    // virtual Grid Mapping

byte RescueLocation[] = { 0, 3};      // Rescue Location variables

void setup ()
{  // put your setup code here, to run once:
  Serial.begin(9600);  // Serial @ 9600 baud
  // set motor pins to output
  pinMode (Lp, OUTPUT);
  pinMode (Ln, OUTPUT);
  pinMode (El, OUTPUT);
  pinMode (Rp, OUTPUT);
  pinMode (Rn, OUTPUT);
  pinMode (Er, OUTPUT);
  // enable H-Bridge
  digitalWrite (El,HIGH);
  digitalWrite (Er,HIGH);
  // set sensors pins to inputs
  pinMode (ERs, INPUT);  
  pinMode (Rs, INPUT);
  pinMode (Ms, INPUT);
  pinMode (Ls, INPUT);
  pinMode (ELs, INPUT);
  pinMode (switchPin, INPUT);
  pinMode (obsSensor, INPUT);
  pinMode (ledPin, OUTPUT);

  // internally pullups are disabled in arduino firmware.
  // to use pullup, enable manually
  digitalWrite (obsSensor,HIGH);
  digitalWrite (switchPin,HIGH);

  // indication of code start
  for(int i=0; i<20; i++)
  {
    digitalWrite(ledPin,LOW);
    delay(50);
    digitalWrite(ledPin,HIGH);
    delay(50);
  }
  delay(2500);    // 2.5sec delay
  
  // press Switch to clear grid info // if pressed indicated with led blink
  if( !digitalRead(switchPin) )
  {
    for(int i=0; i<17; i++)
    {
      EEPROM.write(i, 0);
      digitalWrite(ledPin,LOW);
      delay(50);
      digitalWrite(ledPin,HIGH);
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

  if (EEPROM.read(16) == 0)
  {
    while( nodeCount<16 )              // till all nodes are not discovered
    {
        if( (nodeCount%4 || homeStart) )               // if not column terminating node
        {
          if (homeStart)  { homeStart = false; }    // clear the Home Start Flag
      
            digitalWrite(ledPin,HIGH);    // indicate start line following
            while( (!digitalRead(ERs)) || (!digitalRead(ELs)) )
            {  line_following();  }    // do line following
            MotorControl(0,0);         //when the last sensors are on white stop
            digitalWrite(ledPin,LOW);      // indicate stop line following
            
            if( (digitalRead(ELs)) && (!digitalRead(Ms)) && (digitalRead(ERs)) )  // check for blocking node condition
            {
                delay(50);
                digitalWrite(ledPin,HIGH);    // indicate start line following
                blockingNode = true;   // condition indicates a blocking node
                updateGridInfo();      // update node informtion
                while( (digitalRead(ELs)) || (digitalRead(ERs)) )                    {  MotorControl(1,1);  }
                delay(50);
                digitalWrite(ledPin,LOW);    // indicate start line following
            }
            else  
            {
                updateGridInfo();      // update node informtion
                while( (digitalRead(ELs)) || (digitalRead(ERs)) )    {  line_following();  }
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

    homeRun(myDir);
    EEPROM.write(16, 1);
    while(1);
  }
  else
  {   
      // Print EEPROM Flag whose value now indicates navigation mode
      Serial.println(EEPROM.read(16),DEC);
      Serial.println();
      // Print grid values from the EEPROM
      for(int i=0; i<16; i++)
      {
        Serial.print(EEPROM.read(i),DEC);
        digitalWrite(ledPin,LOW);
        delay(30);
        digitalWrite(ledPin,HIGH);
        delay(30);
      }
      Serial.println();
      
      // call rescueRun to execute rescue operation
      myDir = rescueRun(RescueLocation[0], RescueLocation[1], north);
      MotorControl(1,1);	delay(150);
      MotorControl(0,0);
      change_Dir(myDir, north);     
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
      if     (blockingNode)  
      { gridMap[nodeCount] = 2;  
      blockingNode = false; 
      }
      else   gridMap[nodeCount] = 1;  
      nodeCount++;
  }
  else
  {
       for(int i=0; i<4; i++)
      {
          EEPROM.write(i, gridMap[i]);
      }
      for(int i=7; i>3; i--)
      {
          EEPROM.write(i, gridMap[11-i]);
      }
      for(int i=8; i<12; i++)
      {
          EEPROM.write(i, gridMap[i]);
      }
      for(int i=15; i>11; i--)
      {
          EEPROM.write(i, gridMap[27-i]);
      }
        digitalWrite(ledPin,HIGH);
        delay(50);
        digitalWrite(ledPin,LOW);
        delay(50);
  }
}

