/*
 *  Program: DigitalRead_SerialOut
 *  
 *  Reads an input from the grid sensor panel connected on pins A0,A1,A2,A3,A4 
 *  and prints the result to the serial monitor
 *  Digital Sensor Output:  Black = 0
 *                          White = 1
 *  Serial Baudrate: 9600 baud
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

// LED for indication
#define ledPin  13
// Grid Sensors // holding the bot with gripper oriented outwards
# define ERs  A0
# define Rs   A1
# define Ms   A2
# define Ls   A3
# define ELs  A4

boolean sensorData[5];

void setup()
{
    Serial.begin(9600);
    pinMode(ledPin, OUTPUT); 
  
    pinMode (ERs, INPUT);
    pinMode (Rs, INPUT);
    pinMode (Ms, INPUT);
    pinMode (Ls, INPUT);
    pinMode (ELs, INPUT);
    
    digitalWrite(ledPin,LOW);
}

void loop()
{
    digitalWrite(ledPin,LOW); // lED ON on the shield
    
    sensorData[0] = digitalRead(ERs);
    sensorData[1] = digitalRead(Rs);
    sensorData[2] = digitalRead(Ms);
    sensorData[3] = digitalRead(Ls);
    sensorData[4] = digitalRead(ELs);
    
    serialDisplay();
    
    delay(100);    
    digitalWrite(ledPin,HIGH); // lED OFF on the shield
    delay(100);
}

void serialDisplay()
{
// function to display data stored in sensorData[] to serial port
  Serial.print("Sensor Values are:  ");
  for (int i=0; i<5;i++)
  {
    if(i<4) {
    Serial.print(sensorData[i], BIN);
    Serial.print(", ");
    }
    else
    Serial.println(sensorData[i], BIN);
  }
}

