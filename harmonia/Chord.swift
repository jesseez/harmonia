//
//  Chord.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 3/7/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation


class Chord : NSObject{
    let Values:[UInt8]
    
    init(values:[UInt8]){
        Values = values
    }
    
    init(values:UInt8...){
        Values = values
    }
    
    func getChord()->[UInt8]{
        var temp = [UInt8]()
        temp.append(contentsOf: Values)
        return temp
    }
    
}

