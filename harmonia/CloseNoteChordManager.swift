//
//  CloseNoteChordManager.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 3/2/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class CloseNoteChordManager : ChordManager{
        
    private var Root:UInt8 = 0
    private let _Scale = Scale()
    private var PreviousChord:Chord? = nil
    
    
    private let OctaveDistance = UInt8(12)
    
    init(){}
    
    init(root:UInt8){
        Root = root
    }
    
    func SetRoot(root:UInt8){
        Root = root
        PreviousChord = nil
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
    
    private func getClosestChord(root:UInt8, third:UInt8, fifth:UInt8)->[UInt8]{
        if(PreviousChord == nil){
            return [root, third, fifth]
        }
        let _root = getClosestNote(note: root)
        let _third = getClosestNote(note: third)
        let _fifth = getClosestNote(note: fifth)
        
        return [_root, _third, _fifth]
    }

    private func getClosestNote(note:UInt8)->UInt8{
        
        var bestValue:UInt8 = UInt8(0)
        var nearestValue:UInt8 = UInt8(0)
        
        for chordNote in (PreviousChord?.Values)!{
            
            if(chordNote%OctaveDistance == note%OctaveDistance){
                if( abs(getDistance(note1: chordNote, note2: note)) < abs(getDistance(note1: bestValue, note2: note)) ){
                    bestValue = chordNote
                }
            } else{
                
                let nearestDistance = abs(getDistance(note1: note, note2: nearestValue))%Int(OctaveDistance)
                let chordNoteDistance = abs(getDistance(note1: note, note2: chordNote))%Int(OctaveDistance)

                if (nearestValue == 0 || nearestDistance > chordNoteDistance){
                    nearestValue = chordNote
                }
            }
        }
        
        if(bestValue != 0){
            return bestValue
        } else {
            return UInt8(Int(nearestValue) + getDistance(note1: note, note2: nearestValue)%Int(OctaveDistance))
        }
        
    }

    private func getDistance(note1:UInt8, note2:UInt8)->Int{
        var distance = Int(note1) - Int(note2)

        if(distance > Int(OctaveDistance)/2){
            distance = distance - Int(OctaveDistance)
        } else if(distance  < Int(OctaveDistance) / (-2)){
            distance = distance + Int(OctaveDistance)
        }
        return distance
    }
    
    private func getFinishedChord(root:UInt8, third:UInt8, fifth:UInt8, chordStruct:ChordStructure)->Chord{
        let closest = getClosestChord(root: root, third: third, fifth: fifth)
        
        let newChord = Chord(values: closest)
        PreviousChord = newChord
        return newChord

    }
}



