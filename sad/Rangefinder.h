#ifndef _RANGEFINDER_
#define _RANGEFINDER_

class Range {
public:
  int centimeters;
  int angle;
  
  Range(int centimeters, int angle);
};

class Rangefinder {
private:
  int trigPin;
  int echoPin;
  int angle;
  
  int getMicroseconds();
  int getCentimeters();
  int getAngle();
  
public:
  Rangefinder(int trigPin, int echoPin, int angle);  

  Range ping();
  void setAngle(int angle);
};

#endif

