#include "Rangefinder.h"

Rangefinder::Rangefinder(int trigPin, int echoPin, int angle) {
  this->trigPin = trigPin;
  this->echoPin = echoPin;
  this->angle = angle;
  
  // Configure sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

}

int Rangefinder::scan() {
  int time = 0;
  
  return time;
}

int Rangefinder::getDistance() {
  int distance = 0;  
  int time = scan();
  
  // Calculate distance
  distance = time;
  
  return distance;
}

int Rangefinder::getAngle() {
  return angle;
}

void Rangefinder::setAngle(int angle) {
  this->angle = angle;
 }
