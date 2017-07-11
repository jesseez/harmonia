//
//  ChordType.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class CoreChord : NSObject{
    
    //Major Scale Progression
    
    public static let I = ChordStructure(type: ChordType.major, degree: ScaleDegree.root)
    
    public static let ii = ChordStructure(type: ChordType.minor, degree: ScaleDegree.second)
    
    public static let iii = ChordStructure(type: ChordType.minor, degree: ScaleDegree.third)

    public static let IV = ChordStructure(type: ChordType.major, degree: ScaleDegree.fourth)
    
    public static let V = ChordStructure(type: ChordType.major, degree: ScaleDegree.fifth)

    public static let vi = ChordStructure(type: ChordType.minor, degree: ScaleDegree.sixth)

    public static let viiº = ChordStructure(type: ChordType.diminished, degree: ScaleDegree.seventh)


    
    //Minor Scale Progression
    
    public static let i = ChordStructure(type: ChordType.minor, degree: ScaleDegree.root)
    
    public static let iiº = ChordStructure(type: ChordType.diminished, degree: ScaleDegree.second)
    
    public static let III = ChordStructure(type: ChordType.major, degree: ScaleDegree.third)
    
    public static let iv = ChordStructure(type: ChordType.minor, degree: ScaleDegree.fourth)
    
    //Major fifth already exists
    
    public static let VI = ChordStructure(type: ChordType.major, degree: ScaleDegree.sixth)
    
    public static let VII = ChordStructure(type: ChordType.major, degree: ScaleDegree.seventh)
}
