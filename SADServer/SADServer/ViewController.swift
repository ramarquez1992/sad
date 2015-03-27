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

        println("stopping")
    }
    
    @IBAction func resetMap(AnyObject) {
        stopSLAM()
        
        println("resetting")
    }
    
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
    
    // MARK: - ORSSerialPortDelegate
    
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

            updateReceivedDataTextView(string)
            
            RXBuffer += string
            
            if (bufferContainsCompletePacket(RXBuffer)) {
                var RFData = parseRangefinderData(string)
                addRangefinderDataToMap(RFData)
                
                RXBuffer = ""
            }
            
        }
    }
    
    func bufferContainsCompletePacket(buffer: String) -> Bool {
        var result = false
        
        if (Array(buffer)[countElements(buffer) - 1] == "$") {
            result = true
        }
        
        return result
    }
    
    func updateReceivedDataTextView(string: String) {
        self.receivedDataTextView.textStorage?.mutableString.appendString(string)
        self.receivedDataTextView.needsDisplay = true
        self.receivedDataTextView.scrollToEndOfDocument(self.receivedDataTextView)
    }
    
    func parseRangefinderData(string: String) -> String {
        // Format: "^[number of rangefinders]|[range1 distance],[range1 angle]|[range2 distance],[range2 angle]|...$"
        return string
    }
    
    func addRangefinderDataToMap(RFData: String) {
        print(RFData)
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort!) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort!, didEncounterError error: NSError!) {
        println("SerialPort \(serialPort) encountered an error: \(error)")
    }
    


}

