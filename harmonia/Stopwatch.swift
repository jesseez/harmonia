//
//  Timer.swift
//  Recorder
//
//  Created by Jessee Zhang on 3/14/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class Stopwatch : NSObject{
    
    var startedTime:NSDate?
    
    func reset(){
        startedTime = nil
    }
    
    func start(){
        startedTime = NSDate()
    }
    
    func getElapsedTime()->TimeInterval{
        let now = NSDate()
        let time = now.timeIntervalSince(startedTime! as Date)
        startedTime = now
        return time
    }
}
