#include "Magnetometer.h"

Magnetometer::Magnetometer() {
  Wire.begin();
  setScale(1.3);
  setMeasurementMode(MEASUREMENT_CONTINUOUS);
}

// Takes ~10ms
float Magnetometer::getHeading() { 
  MagnetometerScaled scaled = readScaledAxis();
  float rawHeading = atan2(scaled.YAxis, scaled.XAxis);
  
  rawHeading += DECLINATION_ANGLE;
  
  // Correct for when signs are reversed.
  if (rawHeading < 0)
    rawHeading += 2*PI;
    
  // Check for wrap due to addition of declination.
  if (rawHeading > 2*PI)
    rawHeading -= 2*PI;
   
  // Convert radians to degrees and account for North being 0degrees
  rawHeading = (rawHeading * 180/M_PI) + 90;
  
  if (rawHeading >=360) {
    rawHeading -= 360;
  } else if (rawHeading < 0) {
    rawHeading += 360;
  }
  
  heading = rawHeading;
    
  return heading;
}

