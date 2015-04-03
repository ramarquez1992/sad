# SLAM Arduino Drone

## Goal
Autonomous drone to map 2D space.

## Hardware
* Arduino UNO
* solderless breadboard
* jumper wires
* 9v battery w/ snap connector
* Lithium Battery Backpack for Arduino UNO
* KEDSUM bluetooth transceiver
* Andoer Grove 3-axis digital compass magnetometer
* HC-SR04 ultrasonic distance sensor (1)
* L293DNE h-bridge
* Geeetech reversible gear motor w/ wheel (2)
* Meccano-Erector set
* ball transfer unit
* epoxy

## Software
* Git{,Hub}
* Arduino IDE - C++
* Xcode - Swift
* ORSSerialPort
* Standard C++ for Arduino
* Cocoa
* SpriteKit

## Issues
* minute memory/processing power
1. companion server to compute+display environment

* ultrasonic sensor latency
1. disrupts server communication
2. only scan when not expecting anything from server?
3. laser rangefinders eventually?

* imperfect chassis throws drone off course
1. built in course-correction w/ magnetometer 