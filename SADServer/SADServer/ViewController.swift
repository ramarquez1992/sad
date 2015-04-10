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
    @IBOutlet weak var gridSizeTextField: NSTextField!
    
    @IBOutlet weak var lRangefinderTextField: NSTextField!
    @IBOutlet weak var fRangefinderTextField: NSTextField!
    @IBOutlet weak var rRangefinderTextField: NSTextField!
    
    @IBOutlet weak var speedTextField: NSTextField!
    @IBOutlet weak var headingTextField: NSTextField!
    
    @IBOutlet weak var mapView: SKView!
    var map: MapScene!

    
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
    @IBAction func openOrCloseConnection(sender: AnyObject) {
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
        if (!map.drone.running) {
            startSLAM()
        } else {
            stopSLAM()
        }
    }
    
    @IBAction func resetMap(AnyObject) {
        stopSLAM()
        map.reset()
    }
    
    @IBAction func zoomIn(AnyObject) {
        map.zoom(0.5)
    }
    
    @IBAction func zoomOut(AnyObject) {
        map.zoom(2)
    }
    
    // MARK: - SLAM
    private func startSLAM() {
        map.drone.startSLAM()
        self.startStopButton.title = "STOP"
    }
    
    private func stopSLAM() {
        map.drone.stopSLAM()
        self.startStopButton.title = "START"
    }
    
    // MARK: - Update views
    private func addRangefinderDataToMap(RFData: RangefinderData) {
        if (RFData.distance > 0) {
            map.addPoint(RFData)
        }
    }
    
    private func updateRangefinderViews(RFData: [RangefinderData]) {
        self.fRangefinderTextField.stringValue = "\(RFData[0].distance)\""
    }
    
    private func updateSpeedView(speed: Int) {
        self.speedTextField.stringValue = "\(speed)\"/s"
    }
    
    private func updateHeadingView(heading: CGFloat) {
        self.headingTextField.stringValue = "\(heading)°"
    }
    
    private func updateReceivedDataTextView(string: String) {
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
    
    func didReceivePacket(packet: Packet, rawPacket: String) {
        map.drone.heading = packet.heading
        
        for sensor in packet.RFData {
            addRangefinderDataToMap(sensor)
        }
        
        updateReceivedDataTextView(rawPacket + "\n")
        updateRangefinderViews(packet.RFData)
        updateSpeedView(2)      // TODO: real data for speed view
        updateHeadingView(map.drone.heading)
    }

}

