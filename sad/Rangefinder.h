#ifndef _RANGEFINDER_
#define _RANGEFINDER_

class Rangefinder {
private:
  int trigPin;
  int echoPin;
  int angle;
  
public:
  Rangefinder(int trigPin, int echoPin, int angle);
  ~Rangefinder();
  
  int scan();
  int getDistance();
  int getAngle();
  void setAngle(int angle);

};

#endif
