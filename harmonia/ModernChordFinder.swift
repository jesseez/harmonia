//
//  ModernChordFinder.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class ModernChordFinder : ChordFinder{
    
    var nextChord:[ChordStructure:[WeightedChord]]
    var defaultFirstChord: [WeightedChord]
    var chordMapper:[ChordStructure : Chord]
    
    init(root:UInt8){
        
        let chordFactory = BlockChordManager()
        chordFactory.SetRoot(root: root)
        
        nextChord = [ChordStructure : [WeightedChord]]()
        
        nextChord[CoreChord.I] = [WeightedChord(weight:0.25, chord:CoreChord.V),
                                  WeightedChord(weight:0.19, chord:CoreChord.IV),
                                  WeightedChord(weight:0.1, chord:CoreChord.vi),
                                  WeightedChord(weight:0.06, chord:CoreChord.ii)]
        
        nextChord[CoreChord.IV] = [WeightedChord(weight:0.29, chord:CoreChord.I),
                                   WeightedChord(weight:0.29, chord:CoreChord.V),
                                   WeightedChord(weight:0.1, chord:CoreChord.vi),
                                   WeightedChord(weight:0.05, chord:CoreChord.ii)]
        
        nextChord[CoreChord.V] = [ WeightedChord(weight:0.26, chord:CoreChord.vi),
                                   WeightedChord(weight:0.21, chord:CoreChord.IV),
                                   WeightedChord(weight:0.21, chord:CoreChord.I),
                                   WeightedChord(weight:0.06, chord:CoreChord.ii)]
        
        nextChord[CoreChord.vi] = [WeightedChord(weight:0.24, chord:CoreChord.IV),
                                   WeightedChord(weight:0.20, chord:CoreChord.V),
                                   WeightedChord(weight:0.11, chord:CoreChord.I),
                                   WeightedChord(weight:0.06, chord:CoreChord.ii),
                                   WeightedChord(weight:0.06, chord:CoreChord.iii)]
        
        nextChord[CoreChord.ii] = [ WeightedChord(weight:0.18, chord:CoreChord.vi),
                                    WeightedChord(weight:0.16, chord:CoreChord.IV),
                                    WeightedChord(weight:0.16, chord:CoreChord.V),
                                    WeightedChord(weight:0.13, chord:CoreChord.I),
                                    WeightedChord(weight:0.09, chord:CoreChord.iii)]
        
        nextChord[CoreChord.iii] = [WeightedChord(weight:0.33, chord:CoreChord.IV),
                                    WeightedChord(weight:0.26, chord:CoreChord.vi),
                                    WeightedChord(weight:0.26, chord:CoreChord.ii),
                                    WeightedChord(weight:0.08, chord:CoreChord.V),
                                    WeightedChord(weight:0.05, chord:CoreChord.I)]

        defaultFirstChord = [WeightedChord]()
        
        
        chordMapper = [ChordStructure : Chord]()
        for chord in nextChord.keys{
            if(chord.ChordType == ChordType.major){
                chordMapper[chord] = chordFactory.GetMajorChord(chordStruct: chord)
            } else if(chord.ChordType == ChordType.minor){
                chordMapper[chord] = chordFactory.GetMinorChord(chordStruct: chord)
            } else if(chord.ChordType == ChordType.diminished){
                chordMapper[chord] = chordFactory.GetDiminishedChord(chordStruct: chord)
            }
            
            defaultFirstChord.append(WeightedChord(weight:1, chord:chord))
        }
    }
    
}
