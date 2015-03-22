#ifndef _MOTOR_
#define _MOTOR_

class Motor {
private:
  int enablePin;
  int controlPin1;
  int controlPin2;
  
public:
  Motor(int enablePin, int controlPin1, int controlPin2);
  
  void stop();
  void setSpeed(int speed);
  void accelerate();
  void reverse();
};

#endif

