//
//  NoteBound.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class NoteBound : NSObject{
    
    let note:UInt8
    let upperBound:Double?
    let middleBound:Double
    let lowerBound:Double?
    
    init(note:UInt8, upperBound:Double?, middleBound:Double, lowerBound:Double?){
        self.note = note
        self.upperBound = upperBound
        self.middleBound = middleBound
        self.lowerBound = lowerBound
    }
}
