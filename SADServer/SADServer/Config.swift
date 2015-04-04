//
//  Config.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 4/4/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

let _config = Config()

class Config {
    var plist: [String:AnyObject]
    
    init() {
        if let path = NSBundle.mainBundle().pathForResource("Config", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String:AnyObject] {
                
                plist = dict
                
            } else { fatalError("Failed to load \"Config\" dictionary") }
        } else { fatalError("Failed to load \"Config.plist\"") }
    }
    
    class func getInstance() -> Config {
        return _config
    }
    
    class func get(key: String) -> AnyObject? {
        return Config.getInstance().plist[key]
    }
}