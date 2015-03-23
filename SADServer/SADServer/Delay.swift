//
//  Delay.swift
//  SAD Server
//
//  Created by Marquez, Richard A on 3/22/15.
//  Copyright (c) 2015 Richard Marquez. All rights reserved.
//

import Foundation

func delay(secs: Double, closure: () -> ()) {
    var nsecs = secs * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(nsecs))
    
    dispatch_after(time, dispatch_get_main_queue(), {
        closure()
    })
}