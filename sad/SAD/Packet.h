#ifndef _PACKET_
#define _PACKET_

#include <StandardCplusplus.h>
#include <vector>
#include <numeric>
#include <algorithm>
#include "Rangefinder.h"

using namespace std;

class Packet {
public:
  float heading;
  vector<Range> RFData;
  
  Packet(float heading, vector<Range> RFData);
};

#endif

