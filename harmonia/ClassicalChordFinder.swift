//
//  ClassicalChordFinder.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class ClassicalChordFinder : ChordFinder{
    
    var nextChord:[ChordStructure : [WeightedChord]]
    var chordMapper:[ChordStructure : Chord]
    var defaultFirstChord: [WeightedChord]
    
    init(root:UInt8){
        
        let chordFactory = BlockChordManager()
        chordFactory.SetRoot(root: root)
        
        nextChord = [ChordStructure : [WeightedChord]]()
        
        nextChord[CoreChord.I] = [WeightedChord(weight:1, chord:CoreChord.I),
                                  WeightedChord(weight:0.75, chord:CoreChord.ii),
                                  WeightedChord(weight:0.25, chord:CoreChord.iii),
                                  WeightedChord(weight:1.5, chord:CoreChord.IV),
                                  WeightedChord(weight:1.75, chord:CoreChord.V),
                                  WeightedChord(weight:1.3, chord:CoreChord.vi),
                                  WeightedChord(weight:1.50, chord:CoreChord.viiº)]
        
        nextChord[CoreChord.ii] = [WeightedChord(weight:2, chord:CoreChord.V),
                                   WeightedChord(weight:1.75, chord:CoreChord.viiº),
                                   WeightedChord(weight:1, chord:CoreChord.ii)]
        
        nextChord[CoreChord.iii] = [WeightedChord(weight:1.5, chord:CoreChord.vi),
                                    WeightedChord(weight:1.25, chord:CoreChord.IV),
                                    WeightedChord(weight:1, chord:CoreChord.iii)]
        
        nextChord[CoreChord.IV] = [WeightedChord(weight:2, chord:CoreChord.V),
                                   WeightedChord(weight:1.25, chord:CoreChord.I),
                                   WeightedChord(weight:1.5, chord:CoreChord.ii),
                                   WeightedChord(weight:1.5, chord:CoreChord.viiº),
                                   WeightedChord(weight:1, chord:CoreChord.IV)]
        
        nextChord[CoreChord.V] = [WeightedChord(weight:2, chord:CoreChord.I),
                                  WeightedChord(weight:0.5, chord:CoreChord.vi),
                                  WeightedChord(weight:1, chord:CoreChord.V)]
        
        nextChord[CoreChord.vi] = [WeightedChord(weight:1.25, chord:CoreChord.ii),
                                   WeightedChord(weight:1.5, chord:CoreChord.IV),
                                   WeightedChord(weight:0.5, chord:CoreChord.V),
                                   WeightedChord(weight:1, chord:CoreChord.vi)]
        
        nextChord[CoreChord.viiº] = [WeightedChord(weight:1, chord:CoreChord.I),
                                    WeightedChord(weight:1, chord:CoreChord.V),
                                    WeightedChord(weight:1, chord:CoreChord.viiº)]
        
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
        
        defaultFirstChord = nextChord[CoreChord.I]!
    }
}
