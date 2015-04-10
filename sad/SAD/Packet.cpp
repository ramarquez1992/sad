#include "Packet.h"

Packet::Packet(float heading, vector<Range> RFData) {
    this->heading = heading;
    this->RFData = RFData;
}
