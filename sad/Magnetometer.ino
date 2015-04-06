#include "Magnetometer.h"

Magnetometer::Magnetometer(int address, int sdaPin, int sclPin) {
  this->heading = 12;
  this->address = address;
  this->sdaPin = sdaPin;
  this->sclPin = sclPin;
  
  // Configure sensor
  Wire.begin();
  Wire.beginTransmission(address); //open communication with HMC5883
  Wire.write(0x02); //select mode register
  Wire.write(0x00); //continuous measurement mode
  Wire.endTransmission();
}

// Takes ~10ms
int Magnetometer::getHeading() {  
  //Tell the HMC5883L where to begin reading data
  Wire.beginTransmission(address);
  Wire.write(0x03); //select register 3, X MSB register
  Wire.endTransmission();
  
 //Read data from each axis, 2 registers per axis
  Wire.requestFrom(address, 6);
  if(6<=Wire.available()){
    int x,y,z; //triple axis data

    x = Wire.read()<<8; //X msb
    x |= Wire.read(); //X lsb
    z = Wire.read()<<8; //Z msb
    z |= Wire.read(); //Z lsb
    y = Wire.read()<<8; //Y msb
    y |= Wire.read(); //Y lsb
    
    int rawHeading = atan2(y, x);
    rawHeading += DECLINATION_ANGLE;
    
    if (rawHeading >= 360) {
      rawHeading -= 360;
    } else if (rawHeading < 0) {
      rawHeading += 360;
    }
    
    heading = rawHeading * 180/M_PI;
  }
  
  return heading;
}

