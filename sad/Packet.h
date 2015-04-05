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
  int heading;
  vector<Range> RFData;
  
  Packet(int heading, vector<Range> RFData);
};

Packet::Packet(int heading, vector<Range> RFData) {
  this->heading = heading;
  this->RFData = RFData;
}

#endif

