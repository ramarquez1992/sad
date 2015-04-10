#ifndef _RANGEFINDER_
#define _RANGEFINDER_

#include <Arduino.h>

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>

using namespace std;

#define PING_AVG_CNT 10 // 1ms total ping time

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
  int getInches();
  int getAngle();
  
public:
  Rangefinder(int trigPin, int echoPin, int angle);  

  Range avgPing(int total);
  Range rawPing();
  void setAngle(int angle);
};

#endif

