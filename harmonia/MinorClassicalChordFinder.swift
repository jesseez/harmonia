//
//  MinorClassicalChordFinder.swift
//  harmonia
//
//  Created by Jessee Zhang on 5/22/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class MinorClassicalChordFinder : ChordFinder{
    
    var nextChord:[ChordStructure : [WeightedChord]]
    var chordMapper:[ChordStructure : Chord]
    var defaultFirstChord: [WeightedChord]
    
    init(root:UInt8){
        
        let chordFactory = BlockChordManager()
        chordFactory.SetRoot(root: root)
        
        nextChord = [ChordStructure : [WeightedChord]]()
        
        nextChord[CoreChord.i] = [WeightedChord(weight:1, chord:CoreChord.i),
                                  WeightedChord(weight:0.95, chord:CoreChord.iiº),
                                  WeightedChord(weight:0.01, chord:CoreChord.III),
                                  WeightedChord(weight:1.5, chord:CoreChord.iv),
                                  WeightedChord(weight:1.75, chord:CoreChord.V),
                                  WeightedChord(weight:1.35, chord:CoreChord.VI),
                                  WeightedChord(weight:0.4, chord:CoreChord.VII)]
        
        nextChord[CoreChord.iiº] = [WeightedChord(weight:75, chord:CoreChord.V),
                                    WeightedChord(weight:1, chord:CoreChord.iiº)]
        
        nextChord[CoreChord.III] = [WeightedChord(weight:10, chord:CoreChord.VI),
                                    WeightedChord(weight:1, chord:CoreChord.III)]
        
        nextChord[CoreChord.iv] = [WeightedChord(weight:75, chord:CoreChord.V),
                                    WeightedChord(weight:20, chord:CoreChord.VII),
                                    WeightedChord(weight:35, chord:CoreChord.iiº),
                                    WeightedChord(weight:1, chord:CoreChord.iv)]
        
        nextChord[CoreChord.V] = [WeightedChord(weight:95, chord:CoreChord.i),
                                    WeightedChord(weight:1, chord:CoreChord.V)]
        
        nextChord[CoreChord.VI] = [WeightedChord(weight:45, chord:CoreChord.iv),
                                    WeightedChord(weight:1, chord:CoreChord.VI)]
        
        nextChord[CoreChord.VII] = [WeightedChord(weight:45, chord:CoreChord.i),
                                    WeightedChord(weight:1, chord:CoreChord.VII)]
        
        chordMapper = [ChordStructure : Chord]()
        for chord in nextChord.keys{
            if(chord.ChordType == ChordType.major){
                chordMapper[chord] = chordFactory.GetMajorChord(chordStruct: chord)
            } else if(chord.ChordType == ChordType.minor){
                chordMapper[chord] = chordFactory.GetMinorChord(chordStruct: chord)
            } else if(chord.ChordType == ChordType.diminished){
                chordMapper[chord] = chordFactory.GetDiminishedChord(chordStruct: chord)
            }
        }
        
        defaultFirstChord = nextChord[CoreChord.i]!
    }
}
