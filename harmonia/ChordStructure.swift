//
//  ChordStructure.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 3/7/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation


class ChordStructure : Hashable{
    
    let ChordType:ChordType
    let Degree:ScaleDegree
    let Invert:Inversion
    let OctaveChange:UInt8
    
    init(type:ChordType, degree:ScaleDegree, inversion:Inversion = Inversion.none, octave:Int = 0){
        ChordType = type
        Degree = degree
        Invert = inversion
        OctaveChange = UInt8(octave)
    }
    
    var hashValue: Int {
        return ChordType.hashValue << 16 | Degree.hashValue
    }
}

func == (lhs:ChordStructure, rhs:ChordStructure) -> Bool{
    return (lhs.ChordType == rhs.ChordType && lhs.Degree == rhs.Degree && lhs.Invert == rhs.Invert && lhs.OctaveChange == rhs.OctaveChange)
}

public enum ChordType : UInt8{
    case major = 0
    case minor = 1
    case diminished = 2
}

public enum Inversion : UInt8{
    case none = 0
    case first = 1
    case second = 2
}

public enum ScaleDegree : UInt8{
    case root = 0
    case second = 2
    case third = 4
    case fourth = 5
    case fifth = 7
    case sixth = 9
    case seventh = 11
}

