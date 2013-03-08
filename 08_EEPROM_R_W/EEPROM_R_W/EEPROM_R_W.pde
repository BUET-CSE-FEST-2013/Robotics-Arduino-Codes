/*
 *  Program: EEPROM R/W
 *  
 *  Reads an condition of obstracle sensor connected on Pin3 
 *  If obstracle found on Pin3, enter EEPROM Write Cycle
 *  If obstracle absent, enter EEPROM Write Cycle
 *  EEPROM location once Written needs to be cleared manually
 *  Digital Sensor Output:  Black = 0
 *                          White = 1
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

#include <EEPROM.h>

// LED for indication
#define ledPin  13
// Obstacle Sensor
#define obsSensor  3
// Switch Input
#define switchPin  2

void setup()
{  // put your setup code here, to run once:
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode (obsSensor, INPUT);
  pinMode (switchPin, INPUT);
  
  // internally pullups are disabled in arduino firmware.
  // to use pullup, enable manually
  digitalWrite (obsSensor,HIGH);
  digitalWrite (switchPin,HIGH);
  digitalWrite (ledPin,LOW);
}

void loop()  {
  
  // put your code here to run for ever
  // EEPROM parameters
  int address = 0;
  byte value;
  int count = 1;
  
  if ( digitalRead(obsSensor) )    // to load new values into EEPROM trigger the obstacle sensor once
  {
      // flush EEPROM
      for (int i = 0; i < 50; i++)
      {
          digitalWrite(ledPin, LOW);
          EEPROM.write(i, 0);
          delay(20);
          digitalWrite(ledPin, HIGH);
          delay(20);
      }
      // turn the LED OFF before scanning
      digitalWrite(ledPin, HIGH);
      delay(4000);
      
      for (int i=1;i<50;i++,count++)
      {
          digitalWrite(ledPin, LOW);    // LED on Shield ON
          value = 0;
          while ( !digitalRead(obsSensor) )    // while no obstacle countinue registering value
          {
              if ( !digitalRead(switchPin) )  {  value++; delay(750);  }    // Count incrementation by switch
          }
          EEPROM.write(count, value);          // store values to EEPROM
          EEPROM.write(address, count);        // store count of no of values to EEPROM
          
          digitalWrite(ledPin, HIGH);    // LED on Shield OFF
          delay(2000);    // wait for 1sec
      }
  }
  
  else
  {
      digitalWrite(ledPin, LOW);               // LED on Shield ON
      count = EEPROM.read(address);            // retrive count of no of values from EEPROM
      
      // display count of no of values from EEPROM
      Serial.print("address ");  Serial.print(address);  Serial.print(": ");
      Serial.println(count,DEC);
      Serial.println();
      
      while(count)
      {
          // display values from EEPROM
          address++;
          value = EEPROM.read(address);
          Serial.print("address ");  Serial.print(address);  Serial.print(": ");
          Serial.println(value,DEC);
          count--;
      }
      
      digitalWrite(ledPin, HIGH);               // LED on Shield OFF
      while(1);
  }
}

