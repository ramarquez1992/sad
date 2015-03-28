//
//  ViewController.swift
//  SADServer
//
//  Created by Marquez, Richard A on 3/17/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ORSSerialPortDelegate {

    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    
    var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet weak var connectionSettingsButton: NSButton!
    @IBOutlet weak var sendTextField: NSTextField!
    @IBOutlet var receivedDataTextView: NSTextView!
    
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    
    var RXBuffer: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConnectionSettingsView" {
            var destinationView = segue.destinationController as ConnectionSettingsController
            destinationView.serialPort = serialPort!;
            
        }
    }
    
    ///////
    func gamut() {
        self.sendStr("f")
        delay(1) {
            self.sendStr("r")
            delay(1) {
                self.sendStr("l")
                delay(1) {
                    self.sendStr(" ")
                }
            }
        }
        
    }
    ///////
    
    @IBAction func startOrStopSLAM(AnyObject) {
        //TODO: change conditional to test a 'currentlyRunning' var
        if (self.startStopButton.title == "START") {
            startSLAM()
        } else if (self.startStopButton.title == "STOP") {
            stopSLAM()
        }

    }
    
    func startSLAM() {
        self.startStopButton.title = "STOP"

        println("starting")
        gamut()
    }
    
    func stopSLAM() {
        self.startStopButton.title = "START"

        self.sendStr(" ")

        println("stopping")
    }
    
    @IBAction func resetMap(AnyObject) {
        stopSLAM()
        
        println("resetting")
    }
    
    func addRangefinderDataToMap(RFData: RangefinderData) {
        println("cm: " + String(RFData.distance) + " | angle: " + String(RFData.angle))
    }
    
    func updateReceivedDataTextView(string: String) {
        self.receivedDataTextView.textStorage?.mutableString.appendString(string)
        self.receivedDataTextView.needsDisplay = true
        self.receivedDataTextView.scrollToEndOfDocument(self.receivedDataTextView)
    }
    
    
    // Bluetooth serial communication and parsing

    @IBAction func openOrClosePort(sender: AnyObject) {
        if let port = self.serialPort {
            if (port.open) {
                port.close()
                
                //TODO: change conditional to test a 'currentlyRunning' var
                if (self.startStopButton.title == "STOP") {
                    stopSLAM()
                }
            } else {
                port.open()
                self.receivedDataTextView.textStorage?.mutableString.setString("");
            }
        }
    }
    
    func sendStr(string: String) {
        self.serialPort?.sendData(string.dataUsingEncoding(NSUTF8StringEncoding))
    }
    
    @IBAction func sendManually(AnyObject) {
        sendStr(self.sendTextField.stringValue)
        
        self.sendTextField.stringValue = ""
    }
    
    func serialPortWasOpened(serialPort: ORSSerialPort!) {
        self.openCloseButton.title = "Close"
        connectionSettingsButton.enabled = true
        
        self.startStopButton.enabled = true
        self.resetButton.enabled = true
    }
    
    func serialPortWasClosed(serialPort: ORSSerialPort!) {
        self.openCloseButton.title = "Open"
        connectionSettingsButton.enabled = false
        
        self.startStopButton.enabled = false
        self.resetButton.enabled = false
    }
    
    func serialPort(serialPort: ORSSerialPort!, didReceiveData data: NSData!) {
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            RXBuffer += string
            
            while (RXBuffer.rangeOfString("\n") != nil) {
                if let newlinePos = RXBuffer.rangeOfString("\n")?.startIndex {
                    var fullPacketRange = Range<String.Index>(start: RXBuffer.startIndex, end: newlinePos)
                    var fullPacket = RXBuffer.substringWithRange(fullPacketRange)
                    
                    var sensors: [RangefinderData] = parsePacket(fullPacket)
                    for s in sensors {
                        addRangefinderDataToMap(s)
                    }

                    
                    var remainderRange = Range<String.Index>(start: newlinePos.successor(), end: RXBuffer.endIndex)
                    var remainder = RXBuffer.substringWithRange(remainderRange)
                    
                    RXBuffer = remainder

                }
                
            }
            
        }
    }
    
    func parsePacket(packet: String) -> [RangefinderData] {
        // Format: "([number of rangefinders]|[sensor 1]|[sensor 2]|...)"
        updateReceivedDataTextView("packet: " + packet + "\n")
        
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
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort!) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort!, didEncounterError error: NSError!) {
        println("SerialPort \(serialPort) encountered an error: \(error)")
    }
    


}

