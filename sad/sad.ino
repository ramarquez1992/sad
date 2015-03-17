#include <SoftwareSerial.h>

#define BT_SERIAL_TX_DIO 11 
#define BT_SERIAL_RX_DIO 10
#define BAUD_RATE 9600

SoftwareSerial BluetoothSerial(BT_SERIAL_TX_DIO, BT_SERIAL_RX_DIO);

void setup() {
  BluetoothSerial.begin(BAUD_RATE);

}

void loop() {
  if (BluetoothSerial.available()) {
    BluetoothSerial.write(BluetoothSerial.read());
  }

}
