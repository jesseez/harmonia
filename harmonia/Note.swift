//
//  Note.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class Note : NSObject{
    
    let value:UInt8?
    let length:Length
    
    init(value:UInt8?, length:Length){
        self.value = value
        self.length = length
    }
    
    
}

public enum Length : Double{
    case eighth = 0.5
    case quarter = 1
    case dottedQuarter = 1.5
    case half = 2
    case halfEighth = 2.5
    case dottedHalf = 3
    case doubleDottedHalf = 3.5
    case whole = 4
    case wholeEighth = 4.5
    case wholeQuarter = 5
    case wholeDottedQuarter = 5.5
    case dottedWhole = 6
    case dottedWholeEighth = 6.5
    case doubleDottedWhole = 7
    case doubleDottedWholeEighth = 7.5
    case doubleWhole = 8
    
    public static func get(length:Double) -> Length?{
        //hackish way to avoid doing crazier intervals
        switch length {
        case 0.5:
            return .eighth
        case 1:
            return .quarter
        case 1.5:
            return .dottedQuarter
        case 2:
            return .half
        case 2.5:
            return .halfEighth
        case 3:
            return .dottedHalf
        case 3.5:
            return .doubleDottedHalf
        case 4:
            return .whole
        case 4.5:
            return .wholeEighth
        case 5:
            return .wholeQuarter
        case 5.5:
            return .wholeDottedQuarter
        case 6:
            return .dottedWhole
        case 6.5:
            return .dottedWholeEighth
        case 7:
            return .doubleDottedWhole
        case 7.5:
            return .doubleDottedWholeEighth
        case 8:
            return .doubleWhole
        default:
            return nil
        }
    }
}
