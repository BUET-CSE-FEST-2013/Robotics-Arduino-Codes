/*
 *  Program: LED Blink
 *  
 *  Turns on an LED on for one second, then off for one second, repeatedly.
 *  
 *  Author: Robosoft Systems for Nexus Workshop
*/

// LED for indication
#define ledPin  13

void setup() {                
  // initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards:
  pinMode(ledPin, OUTPUT);
}

void loop() {
  digitalWrite(ledPin, HIGH);   // set the LED on
  delay(1000);              // wait for a second
  digitalWrite(ledPin, LOW);    // set the LED off
  delay(1000);              // wait for a second
}
