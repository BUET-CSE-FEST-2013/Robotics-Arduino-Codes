/*
 *  Program: Obstacle Detection
 *  
 *  Reads an condition of obstacle Sensor connected on Pin3 
 *  If obstracle found on Pin3, lED ON else OFF
 *  Digital Sensor Output:  Black = 0
 *                          White = 1
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

// LED for indication
#define ledPin  13
// Obstracle Sensor
#define obsSensor  3

void setup()
{  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode (obsSensor, INPUT);
  
  // internally pullups are disabled in arduino firmware
  // to use pullup, enable manually
  digitalWrite(3,HIGH) ;
  
}

void loop()  {
  
  // put your code here to run for ever
  if ( digitalRead(obsSensor) )
      digitalWrite(13, LOW);
 else
      digitalWrite(13, HIGH);
}

