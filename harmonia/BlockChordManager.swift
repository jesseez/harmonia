//
//  BlockChordManager.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 2/22/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class BlockChordManager : ChordManager{
    
    private var Root:UInt8 = 0
    private let _Scale = Scale()
    
    
    func SetRoot(root:UInt8){
        Root = root
    }
    
    func GetMajorChord(chordStruct: ChordStructure)->Chord{
        setScaleRoot(degree: chordStruct.Degree)
        
        let root = _Scale.getRoot()
        let third = _Scale.getMajorThird()
        let fifth = _Scale.getFifth()
        
        return getFinishedChord(root: root, third: third, fifth: fifth, chordStruct: chordStruct)
    }
    
    func GetMinorChord(chordStruct: ChordStructure) -> Chord {
        setScaleRoot(degree: chordStruct.Degree)
        
        let root = _Scale.getRoot()
        let third = _Scale.getMinorThird()
        let fifth = _Scale.getFifth()
        
        return getFinishedChord(root: root, third: third, fifth: fifth, chordStruct: chordStruct)

    }
    
    func GetDiminishedChord(chordStruct: ChordStructure) -> Chord {
        setScaleRoot(degree: chordStruct.Degree)
        
        let root = _Scale.getRoot()
        let third = _Scale.getMinorThird()
        let fifth = _Scale.getTritone()
        
        return getFinishedChord(root: root, third: third, fifth: fifth, chordStruct: chordStruct)
    }
    
    private func setScaleRoot(degree: ScaleDegree){
        let newRoot = Root + degree.rawValue
        _Scale.setRoot(root: newRoot)
    }
    
    
    private func getFinishedChord(root: UInt8, third: UInt8, fifth: UInt8, chordStruct: ChordStructure)->Chord{
        let chord = Chord(values: root, third, fifth)
        
        return chord
    }
    
}
