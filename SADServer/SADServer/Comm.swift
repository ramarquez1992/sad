//
//  Comm.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/29/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

let _comm = Comm()

// MARK: CommDelegate
protocol CommDelegate {
    func connectionWasOpened();
    func connectionWasClosed();
    func didReceivePacket(packet: Packet, rawPacket: String);
}

// MARK: -
class Comm: NSObject, ORSSerialPortDelegate {
    var delegate: CommDelegate?
    private var RXBuffer: String = ""
    
    class func getInstance() -> Comm {
        return _comm
    }

    // MARK: - Packet parsing
    func parsePacket(packetStr: String) -> Packet {
        // Format: "([number of rangefinders]|[sensor 1]|[sensor 2]|...<[heading]>)"
        var packet = Packet()
        
        packet.heading = getHeading(packetStr)
        
        var rangefinderStrs = separateSensors(packetStr)
        for rangefinder in rangefinderStrs {
            packet.RFData.append(parseSensor(rangefinder))
        }
        
        return packet
    }
    
    private func isValidPacket(packet: String) -> Bool {
        var result = false
        
        let fullPattern = "^\\([0-9]+(\\|[0-9]+,[0-9]+)+<[0-9]+>\\)$"
        let regex = NSRegularExpression(pattern: fullPattern, options: nil, error: nil)
        
        if (regex?.rangeOfFirstMatchInString(packet, options: nil, range: NSMakeRange(0, countElements(packet))).location != NSNotFound) {
            result = true
        }
        
        return result
    }
    
    private func getHeading(packet: String) -> CGFloat {
        var heading = 20
        
        let headingPattern = "^\\([0-9]+(?:\\|[0-9]+,[0-9]+)+<([0-9]+)>\\)$"
        let regex = NSRegularExpression(pattern: headingPattern, options: nil, error: nil)
        
        heading = regex!.stringByReplacingMatchesInString(packet,
            options: nil,
            range: NSRange(location: 0, length: countElements(packet)),
            withTemplate: "$1").toInt()!
        
        return CGFloat(heading)
    }
    
    private func separateSensors(packet: String) -> [String] {
        var sensors = [String]()
        
        let sensorPattern = "\\|([0-9]+,[0-9]+)(.*)"
        let regex = NSRegularExpression(pattern: sensorPattern, options: nil, error: nil)
        
        let sensorCount = getSensorCount(packet)
        var remainder = getAllSensors(packet)

        for (var i = 0; i < sensorCount; ++i) {
            
            var firstSensor = regex!.stringByReplacingMatchesInString(remainder,
                options: nil,
                range: NSRange(location: 0, length: countElements(remainder)),
                withTemplate: "$1")
            sensors.append(firstSensor)
            
            remainder = regex!.stringByReplacingMatchesInString(remainder,
                options: nil,
                range: NSRange(location: 0, length: countElements(remainder)),
                withTemplate: "$2")
            
        }
        
        return sensors
    }
    
    private func getSensorCount(packet: String) -> Int {
        var sensorCount = 0
        
        let sensorCountPattern = "^\\(([0-9]+)(\\|[0-9]+,[0-9]+)+<[0-9]+>\\)$"
        let regex = NSRegularExpression(pattern: sensorCountPattern, options: nil, error: nil)
        
        sensorCount = regex!.stringByReplacingMatchesInString(packet,
            options: nil,
            range: NSRange(location: 0, length: countElements(packet)),
            withTemplate: "$1").toInt()!
        
        return sensorCount
    }
    
    private func getAllSensors(packet: String) -> String {
        var allSensors: String
        
        let allSensorsPattern = "^\\([0-9]+((\\|[0-9]+,[0-9]+)+)<[0-9]+>\\)$"
        let regex = NSRegularExpression(pattern: allSensorsPattern, options: nil, error: nil)
        
        allSensors = regex!.stringByReplacingMatchesInString(packet,
            options: nil,
            range: NSRange(location: 0, length: countElements(packet)),
            withTemplate: "$1")
        
        return allSensors
    }
    
    private func parseSensor(sensor: String) -> RangefinderData {
        var distance = 0
        var angle = 0

        let sensorPattern = "([0-9]+),([0-9]+)"
        let regex = NSRegularExpression(pattern: sensorPattern, options: nil, error: nil)
        
        distance = regex!.stringByReplacingMatchesInString(sensor,
            options: nil,
            range: NSRange(location: 0, length: countElements(sensor)),
            withTemplate: "$1").toInt()!
        
        angle = regex!.stringByReplacingMatchesInString(sensor,
            options: nil,
            range: NSRange(location: 0, length: countElements(sensor)),
            withTemplate: "$2").toInt()!
        
        return RangefinderData(distance: CGFloat(distance), angle: CGFloat(angle))
    }
    
    
    // MARK: - ORSSerialPort
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
                    
                    if (isValidPacket(fullPacket)) {
                        delegate?.didReceivePacket(parsePacket(fullPacket), rawPacket: fullPacket)
                    } else {
                        println("INVALID PACKET: " + fullPacket)
                    }
                    
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

