#ifndef _RANGEFINDER_
#define _RANGEFINDER_

class Range {
public:
  int distance;
  int angle;
  
  Range(int distance, int angle);
};

class Rangefinder {
private:
  int trigPin;
  int echoPin;
  int angle;
  
  int getTime();
  int getDistance();
  int getAngle();
  
public:
  Rangefinder(int trigPin, int echoPin, int angle);
  ~Rangefinder();
  

  Range* scan();
  void setAngle(int angle);

};

#endif
