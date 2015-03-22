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
    
    @IBOutlet weak var sendTextField: NSTextField!
    @IBOutlet var receivedDataTextView: NSTextView!
    @IBOutlet weak var openCloseButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConnectionSettingsView" {
            var destinationView = segue.destinationController as ConnectionSettingsController
            destinationView.serialPort = serialPort!;
            
        }
    }

    @IBAction func send(AnyObject) {
        let data = self.sendTextField.stringValue.dataUsingEncoding(NSUTF8StringEncoding)
        self.serialPort?.sendData(data)
        
        self.sendTextField.stringValue = ""

    }
    
    @IBAction func openOrClosePort(sender: AnyObject) {
        if let port = self.serialPort {
            if (port.open) {
                port.close()
            } else {
                port.open()
                self.receivedDataTextView.textStorage?.mutableString.setString("");
            }
        }
    }
    
    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasOpened(serialPort: ORSSerialPort!) {
        self.openCloseButton.title = "Close"
    }
    
    func serialPortWasClosed(serialPort: ORSSerialPort!) {
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort!, didReceiveData data: NSData!) {
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
            self.receivedDataTextView.textStorage?.mutableString.appendString(string)
            
            self.receivedDataTextView.needsDisplay = true
            self.receivedDataTextView.scrollToEndOfDocument(self.receivedDataTextView)
        }
    }
    
    func serialPortWasRemovedFromSystem(serialPort: ORSSerialPort!) {
        self.serialPort = nil
        self.openCloseButton.title = "Open"
    }
    
    func serialPort(serialPort: ORSSerialPort!, didEncounterError error: NSError!) {
        println("SerialPort \(serialPort) encountered an error: \(error)")
    }
    


}

