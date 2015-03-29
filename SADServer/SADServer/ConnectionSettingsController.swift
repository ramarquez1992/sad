//
//  ConnectionSettingsController.swift
//  SADServer
//
//  Created by Marquez, Richard A on 3/22/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//


import Cocoa

class ConnectionSettingsController: NSViewController {
    
    let comm = _comm
    let availableBaudRates = [300, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 38400, 57600, 115200, 230400]

    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
 
}

