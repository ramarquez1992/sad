//
//  Comm.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/29/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

let _comm = Comm()

protocol CommDelegate {
    func connectionWasOpened();
    func connectionWasClosed();
    func didReceivePacket(data: [RangefinderData]);
}

class Comm: NSObject, ORSSerialPortDelegate {
    var delegate: CommDelegate?
    var RXBuffer: String = ""
    
    func parsePacket(packet: String) -> [RangefinderData] {
        // Format: "([number of rangefinders]|[sensor 1]|[sensor 2]|...)"
        var sensorData: [RangefinderData] = []
        
        // Exit early if packet is invalid
        var regex = NSRegularExpression(pattern: "^\\([0-9]+(\\|[0-9]+,[0-9]+)+\\)$", options: nil, error: nil)
        if (regex?.rangeOfFirstMatchInString(packet, options: nil, range: NSMakeRange(0, countElements(packet))).location == NSNotFound) {
            return sensorData
        }
        
        if let firstPipePos = packet.rangeOfString("|")?.startIndex {
            // Get number of sensors
            var sensorCountRange = Range<String.Index>(start: packet.startIndex.successor(), end: firstPipePos)
            var sensorCount: Int = packet.substringWithRange(sensorCountRange).toInt()!
            
            // Remove number of sensors
            var newPacketRange = Range<String.Index>(start: firstPipePos.successor(), end: packet.endIndex)
            var newPacket = packet.substringWithRange(newPacketRange)
            
            // Get all intermediate sensors
            for (var i = 0; i < (sensorCount - 1); ++i) {
                if let nextPipePos = newPacket.rangeOfString("|")?.startIndex {
                    // Get next sensor in packet
                    var sensorRange = Range<String.Index>(start: newPacket.startIndex, end: nextPipePos)
                    var sensor = newPacket.substringWithRange(sensorRange)
                    sensorData.append(parseSensor(sensor))
                    
                    // Remove sensor from packet
                    newPacketRange = Range<String.Index>(start: nextPipePos.successor(), end: newPacket.endIndex)
                    newPacket = newPacket.substringWithRange(newPacketRange)
                }
            }
            
            // Get last sensor
            newPacketRange = Range<String.Index>(start: newPacket.startIndex, end: newPacket.endIndex.predecessor())
            newPacket = newPacket.substringWithRange(newPacketRange)
            
            sensorData.append(parseSensor(newPacket))
            
        }
        
        return sensorData
    }
    
    func parseSensor(sensor: String) -> RangefinderData {
        // Format: "[distance],[angle]"
        var distance: Int = 0;
        var angle: Int = 0;
        
        if let commaPos = sensor.rangeOfString(",")?.startIndex {
            var distanceRange = Range<String.Index>(start: sensor.startIndex, end: commaPos)
            distance = sensor.substringWithRange(distanceRange).toInt()!
            
            var angleRange = Range<String.Index>(start: commaPos.successor(), end: sensor.endIndex)
            angle = sensor.substringWithRange(angleRange).toInt()!
        }
        
        
        return RangefinderData(distance: distance, angle: angle)
    }

    
    // ORSSerialPort communication
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    func isOpen() -> Bool {
        var status = false
        
        if let port = self.serialPort {
            status = port.open
        }
        
        return status
    }
    
    func open() {
        if let port = self.serialPort {
            port.open()
            port.baudRate = 9600
        }
    }
    
    func close() {
        if let port = self.serialPort {
            port.close()
        }
    }
    
    func sendStr(string: String) {
        self.serialPort?.sendData(string.dataUsingEncoding(NSUTF8StringEncoding))
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort!) {
        delegate?.connectionWasOpened()
    }
    
    func serialPortWasClosed(serialPort: ORSSerialPort!) {
        delegate?.connectionWasClosed()
    }
    
    func serialPort(serialPort: ORSSerialPort!, didReceiveData data: NSData!) {
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            RXBuffer += string
            
            // Send any full packets out to be parsed
            while (RXBuffer.rangeOfString("\n") != nil) {
                if let newlinePos = RXBuffer.rangeOfString("\n")?.startIndex {
                    var fullPacketRange = Range<String.Index>(start: RXBuffer.startIndex, end: newlinePos)
                    var fullPacket = RXBuffer.substringWithRange(fullPacketRange)
                    
                    delegate?.didReceivePacket(parsePacket(fullPacket))
                    
                    var remainderRange = Range<String.Index>(start: newlinePos.successor(), end: RXBuffer.endIndex)
                    var remainder = RXBuffer.substringWithRange(remainderRange)
                    
                    RXBuffer = remainder
                    
                }
            }
        }
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort!) {
        self.serialPort = nil
    }
    
    func serialPort(serialPort: ORSSerialPort!, didEncounterError error: NSError!) {
        println("SerialPort \(serialPort) encountered an error: \(error)")
    }
    
}

