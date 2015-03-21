#include "Rangefinder.h"

Range::Range(int distance, int angle) {
  this->distance = distance;
  this->angle = angle;
}

Rangefinder::Rangefinder(int trigPin, int echoPin, int angle) {
  this->trigPin = trigPin;
  this->echoPin = echoPin;
  this->angle = angle;
  
  // Configure sensor
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

}

Range* Rangefinder::scan() {
  return new Range(getDistance(), getAngle());
}

int Rangefinder::getTime() {
  int time = 0;
  
  return time;
}

int Rangefinder::getDistance() {
  int distance = 0;  
  int time = getTime();
  
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
