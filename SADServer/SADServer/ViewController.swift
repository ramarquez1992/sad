//
//  ViewController.swift
//  SADServer
//
//  Created by Marquez, Richard A on 3/17/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController, CommDelegate {
    
    let comm = Comm.getInstance()
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    
    @IBOutlet weak var openCloseButton: NSButton!
    @IBOutlet weak var connectionSettingsButton: NSButton!
    @IBOutlet weak var sendTextField: NSTextField!
    @IBOutlet var receivedDataTextView: NSTextView!
    
    @IBOutlet weak var startStopButton: NSButton!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var mapView: SKView!
    
    @IBOutlet weak var lRangefinderTextField: NSTextField!
    @IBOutlet weak var fRangefinderTextField: NSTextField!
    @IBOutlet weak var rRangefinderTextField: NSTextField!
    
    @IBOutlet weak var speedTextField: NSTextField!
    @IBOutlet weak var headingTextField: NSTextField!
    
    var map: MapScene?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comm.delegate = self
        
        if let scene = MapScene.unarchiveFromFile("MapScene") as? MapScene {
            mapView.ignoresSiblingOrder = true      // Sprite Kit rendering performance optimizations
            scene.scaleMode = .AspectFill           // Set the scale mode to scale to fit the window
            
            mapView.presentScene(scene)
            map = scene
        }
    }
    
    // MARK: - IBAction
    @IBAction func openOrClosePort(sender: AnyObject) {
        if (comm.isOpen()) {
            comm.close()
            
            // Stop drone if currently running
            if (self.startStopButton.title == "STOP") {
                stopSLAM()
            }
        } else {
            comm.open()
            self.receivedDataTextView.textStorage?.mutableString.setString("");
        }
    }
    
    @IBAction func sendManually(AnyObject) {
        comm.sendStr(self.sendTextField.stringValue)
        
        self.sendTextField.stringValue = ""
    }
    
    @IBAction func startOrStopSLAM(AnyObject) {
        // TODO: change conditional to test a 'currentlyRunning' var
        if (self.startStopButton.title == "START") {
            startSLAM()
        } else if (self.startStopButton.title == "STOP") {
            stopSLAM()
        }
    }
    
    @IBAction func resetMap(AnyObject) {
        stopSLAM()
        map?.reset()
    }
    
    @IBAction func zoomIn(AnyObject) {
        println("zooming in")
    }
    
    @IBAction func zoomOut(AnyObject) {
        println("zooming out")
    }
    
    // MARK: -
    func startSLAM() {
        self.startStopButton.title = "STOP"
        
        map?.addRandomPoints(5)
    }
    
    func stopSLAM() {
        comm.sendStr(" ")       // Stop drone

        self.startStopButton.title = "START"
    }
    
    // MARK: - Update views
    func addRangefinderDataToMap(RFData: RangefinderData) {
        // TODO: actually add to map
        //(mapView.scene as MapScene).addPoint(RFData)
    }
    
    func updateRangefinderViews(RFData: [RangefinderData]) {
        self.fRangefinderTextField.stringValue = String(RFData[0].distance) + "\""
    }
    
    func updateSpeedView(speed: Int) {
        self.speedTextField.stringValue = String(speed) + "\"/s"
    }
    
    func updateHeadingView(heading: Int) {
        self.headingTextField.stringValue = String(heading) + "°"
    }
    
    func updateReceivedDataTextView(string: String) {
        var df = NSDateFormatter()
        df.dateFormat = "[kk:mm:ss]  "
        var date = df.stringFromDate(NSDate())
        
        self.receivedDataTextView.textStorage?.mutableString.appendString(date + string)
        self.receivedDataTextView.needsDisplay = true
        self.receivedDataTextView.scrollToEndOfDocument(self.receivedDataTextView)
    }
    
    // MARK: - CommDelegate
    func connectionWasOpened() {
        self.openCloseButton.title = "Close"
        connectionSettingsButton.enabled = true
        
        self.startStopButton.enabled = true
        self.resetButton.enabled = true
    }
    
    func connectionWasClosed() {
        self.openCloseButton.title = "Open"
        connectionSettingsButton.enabled = false
        
        self.startStopButton.enabled = false
        self.resetButton.enabled = false
    }
    
    func didReceivePacket(data: [RangefinderData], rawPacket: String) {
        updateReceivedDataTextView(rawPacket + "\n")
        updateRangefinderViews(data)
        updateSpeedView(2)      // TODO: use real data
        updateHeadingView(90)   // TODO: use real data

        for sensor in data {
            addRangefinderDataToMap(sensor)
        }
    }

    /*override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ConnectionSettingsView" {
            var destinationView = segue.destinationController as ConnectionSettingsController
            destinationView.serialPort = serialPort!;
            
        }
    }*/
}

// MARK: -
extension SKNode {
    
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as SKScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
    
}

