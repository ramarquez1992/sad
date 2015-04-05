#include "Magnetometer.h"

Magnetometer::Magnetometer(int trigPin, int echoPin) {
  this->trigPin = trigPin;
  this->echoPin = echoPin;
  
  // Configure sensor
  //pinMode(trigPin, OUTPUT);
  //digitalWrite(trigPin, LOW);
}

int Magnetometer::getHeading() {
  return 12;
}

