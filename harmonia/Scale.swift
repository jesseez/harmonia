//
//  Scale.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 2/21/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class Scale : NSObject {
    
    public static let OCTAVE_LENGTH = UInt8(12)
    
    private var Root:UInt8 = 0
    
    override init(){}
    
    init(root:UInt8){
        Root = root
    }
    
    func setRoot(root:UInt8){
        Root = root
    }
    
    func getRoot(octave:Int = 0)->UInt8 {
        return getRootAtOctave(octave: octave)
    }
    
    func getMinorSecond(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 1
        return note
    }
    
    func getMajorSecond(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 2
        return note
    }
    
    func getMinorThird(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 3
        return note
    }
    
    func getMajorThird(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 4
        return note
    }
    
    func getFourth(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 5
        return note
    }
    
    func getTritone(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 6
        return note
    }
    
    func getFifth(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 7
        return note
    }
    
    func getMinorSixth(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 8
        return note
    }
    
    func getMajorSixth(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 9
        return note
    }
    
    func getMinorSeventh(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 10
        return note
    }
    
    func getMajorSeventh(octave:Int = 0)->UInt8 {
        let note = getRootAtOctave(octave: octave) + 11
        return note
    }
    
    private func getRootAtOctave(octave:Int)->UInt8{
        let octaveChange = octave * 12
        let newOctave = UInt8(Int(Root) + octaveChange)         //because UInt8s cant be negative
        return UInt8(newOctave)
    }
    
    func getMajorScale() -> [UInt8]{
        var scale = [UInt8]()
        
        scale.append(getRoot())
        scale.append(getMajorSecond())
        scale.append(getMajorThird())
        scale.append(getFourth())
        scale.append(getFifth())
        scale.append(getMajorSixth())
        scale.append(getMajorSeventh())
        scale.append(getRoot(octave: 1))
    
        return scale
    }
    
    func getMinorScale() -> [UInt8]{
        var scale = [UInt8]()
        
        scale.append(getRoot())
        scale.append(getMajorSecond())
        scale.append(getMinorThird())
        scale.append(getFourth())
        scale.append(getFifth())
        scale.append(getMinorSixth())
        scale.append(getMajorSeventh())
        scale.append(getRoot(octave: 1))
        
        return scale
    }
    
}
