/*
 *  Program: Serial Echo
 *  
 *  Reads serial input data and echos back
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

char inByte;  // incoming serial byte

void setup() {
// put your setup code here, to run once:
  Serial.begin(9600);          // serial communication baud rate
  }


void loop() {
// while loop begins here, continous loop:
  if (Serial.available()) {    // check for incoming data --> if available
  inByte = Serial.read();      // store incoming data
  Serial.print(inByte);        // echo back the data
}

}// while loop ends here
