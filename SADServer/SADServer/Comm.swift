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
    // Format: "([number of rangefinders]|[sensor 1]|[sensor 2]...<[heading]>)"
    private func isValidPacket(packet: String) -> Bool {
        var valid = false
        
        let validPacketPattern = "^\\([0-9]+(\\|[0-9]+,[0-9]+)+<[0-9]+>\\)$"
        let regex = NSRegularExpression(pattern: validPacketPattern, options: nil, error: nil)
        
        if (regex?.rangeOfFirstMatchInString(packet, options: nil, range: NSMakeRange(0, count(packet))).location != NSNotFound) {
            valid = true
        }
        
        return valid
    }
    
    private func parsePacket(packetStr: String) -> Packet {
        let heading = getHeading(packetStr)
        let RFData = getRangefinders(packetStr)
        
        return Packet(heading: heading, RFData: RFData)
    }

    private func getHeading(packet: String) -> CGFloat {
        let headingPattern = "^\\([0-9]+(?:\\|[0-9]+,[0-9]+)+<([0-9]+)>\\)$"
        let regex = NSRegularExpression(pattern: headingPattern, options: nil, error: nil)
        
        let heading = regex!.stringByReplacingMatchesInString(packet,
            options: nil,
            range: NSRange(location: 0, length: count(packet)),
            withTemplate: "$1").toInt()!
        
        return CGFloat(heading)
    }
    
    private func getRangefinders(packet: String) -> [RangefinderData] {
        let rangefinderStrs = separateRangefinderStrs(packet)
        var RFData = [RangefinderData]()

        for rangefinderStr in rangefinderStrs {
            RFData.append(parseRangefinder(rangefinderStr))
        }
        
        return RFData
    }
    
    private func separateRangefinderStrs(packet: String) -> [String] {
        let rangefinderPattern = "\\|([0-9]+,[0-9]+)(.*)"
        let regex = NSRegularExpression(pattern: rangefinderPattern, options: nil, error: nil)
        
        let rangefinderCount = getRangefinderCount(packet)
        var remainder = getAllRangefinderStrs(packet)

        var rangefinderStrs = [String]()
        for (var i = 0; i < rangefinderCount; ++i) {
            let firstRangefinder = regex!.stringByReplacingMatchesInString(remainder,
                options: nil,
                range: NSRange(location: 0, length: count(remainder)),
                withTemplate: "$1")
            rangefinderStrs.append(firstRangefinder)
            
            remainder = regex!.stringByReplacingMatchesInString(remainder,
                options: nil,
                range: NSRange(location: 0, length: count(remainder)),
                withTemplate: "$2")
        }
        
        return rangefinderStrs
    }
    
    private func getRangefinderCount(packet: String) -> Int {
        let rangefinderCountPattern = "^\\(([0-9]+)(\\|[0-9]+,[0-9]+)+<[0-9]+>\\)$"

        let regex = NSRegularExpression(pattern: rangefinderCountPattern, options: nil, error: nil)
        
        let rangefinderCount = regex!.stringByReplacingMatchesInString(packet,
            options: nil,
            range: NSRange(location: 0, length: count(packet)),
            withTemplate: "$1").toInt()!
        
        return rangefinderCount
    }
    
    private func getAllRangefinderStrs(packet: String) -> String {
        let allRangefindersPattern = "^\\([0-9]+((\\|[0-9]+,[0-9]+)+)<[0-9]+>\\)$"

        let regex = NSRegularExpression(pattern: allRangefindersPattern, options: nil, error: nil)
        
        let allRangefinders = regex!.stringByReplacingMatchesInString(packet,
            options: nil,
            range: NSRange(location: 0, length: count(packet)),
            withTemplate: "$1")
        
        return allRangefinders
    }
    
    private func parseRangefinder(rangefinderStr: String) -> RangefinderData {
        let rangefinderPattern = "([0-9]+),([0-9]+)"
        let regex = NSRegularExpression(pattern: rangefinderPattern, options: nil, error: nil)
        
        let distance = regex!.stringByReplacingMatchesInString(rangefinderStr,
            options: nil,
            range: NSRange(location: 0, length: count(rangefinderStr)),
            withTemplate: "$1").toInt()!
        
        let angle = regex!.stringByReplacingMatchesInString(rangefinderStr,
            options: nil,
            range: NSRange(location: 0, length: count(rangefinderStr)),
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
            // Not guaranteed quantity of data received, so add to a buffer
            RXBuffer += string as String
            
            // Send any full packets (separated by newline) out to be parsed
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

