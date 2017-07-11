//
//  HarmonyFactory.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation
class HarmonyFactory : NSObject{
    
    public static func generateClassicalHarmony(root:UInt8, melody:[Note], beatsPerMeasure:Double)->[Chord]{
        
        let chordFinder = ClassicalChordFinder(root: root)
        return generateHarmony(root: root, melody: melody, beatsPerMeasure: beatsPerMeasure, chordFinder: chordFinder)
        
    }
    
    
    
    public static func generateModernHarmony(root:UInt8, melody:[Note], beatsPerMeasure:Double)->[Chord]{
        
        let chordFinder = ModernChordFinder(root: root)
        return generateHarmony(root: root, melody: melody, beatsPerMeasure: beatsPerMeasure, chordFinder: chordFinder)
        
    }
    
    
    public static func generateMinorClassicalHarmony(root:UInt8, melody:[Note], beatsPerMeasure:Double)->[Chord]{
        
        let chordFinder = MinorClassicalChordFinder(root: root)
        return generateHarmony(root: root, melody: melody, beatsPerMeasure: beatsPerMeasure, chordFinder: chordFinder)

    }
    
    
    private static func generateHarmony(root:UInt8, melody:[Note], beatsPerMeasure:Double, chordFinder:ChordFinder)->[Chord]{
        let melodyReader = MelodyReader(melody: melody, beatsPerMeasure: beatsPerMeasure)
        let chordGenerator = CloseNoteChordManager(root: root)
        
        var harmony = [Chord]()
        
        var prev:ChordStructure? = nil
        var curr:ChordStructure? = nil
        
        var measures = 0
        
        while(melodyReader.hasNext()){
            let measure = melodyReader.getNextMeasure()
            
            curr = chordFinder.findChord(measure: measure, previous: prev)
            prev = curr
            
            var chord:Chord? = nil
            
            if(curr?.ChordType == ChordType.major){
                chord = chordGenerator.GetMajorChord(chordStruct: curr!)
            } else if(curr?.ChordType == ChordType.minor){
                chord = chordGenerator.GetMinorChord(chordStruct: curr!)
            } else if(curr?.ChordType == ChordType.diminished){
                chord = chordGenerator.GetDiminishedChord(chordStruct: curr!)
            } else{
                chord = Chord()
            }
            
            harmony.append(chord!)
            measures += 1
        }
        
        return harmony
    }
    
}
