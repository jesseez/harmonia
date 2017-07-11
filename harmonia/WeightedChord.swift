//
//  WeightedChord.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class WeightedChord : NSObject{
    
    let weight:Double
    let chord:ChordStructure
    
    init(weight:Double, chord:ChordStructure){
        self.weight = weight
        self.chord = chord
    }
    
}
