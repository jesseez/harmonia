//
//  ChordManager.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 2/21/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

protocol ChordManager {
    
    
    //Returns a major chord of certain type
    func GetMajorChord(chordStruct:ChordStructure)->Chord
    
    //Returns a minor chord of certain type
    func GetMinorChord(chordStruct:ChordStructure)->Chord
    
    //Returns a diminished chord of a certain type
    func GetDiminishedChord(chordStruct:ChordStructure)->Chord
    
    //Sets the root note
    func SetRoot(root:UInt8)
    
}

