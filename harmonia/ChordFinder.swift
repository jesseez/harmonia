//
//  ChordFinder.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

protocol ChordFinder {
    
    var nextChord:[ChordStructure : [WeightedChord]] {get}
    var chordMapper:[ChordStructure : Chord] {get}
    var defaultFirstChord:[WeightedChord] {get}
    
    //Find the chord that best fits with the measure based on the previous chord
    func findChord(measure:[Note], previous:ChordStructure?)->ChordStructure?
    
    //Find the chord that best fits with the measure based on the previous chord
    func findChord(measure:[Note])->ChordStructure?
}

extension ChordFinder{
    
    
    //Find the chord that best fits with the measure based on the previous chord
    func findChord(measure:[Note], previous:ChordStructure?)->ChordStructure?{
        let potentialChords:[WeightedChord]
        
        if(previous == nil){
            return findChord(measure: measure)
        } else {
            potentialChords = nextChord[previous!]!
        }
        
        return findChord(measure: measure, potentialChords: potentialChords)
    }
    
    //Find the chord that best fits with the measure based on the previous chord
    func findChord(measure:[Note])->ChordStructure?{
        
        return findChord(measure: measure, potentialChords: defaultFirstChord)
        
        
    }
    
    private func findChord(measure:[Note], potentialChords:[WeightedChord]) -> ChordStructure?{
        var best:ChordStructure? = nil
        var bestValue = 0.0
        var conflicts = [ChordStructure]()
        
        for weighted in potentialChords{
            let chord = chordMapper[weighted.chord]
            let total = calculateMappingValue(measure: measure, chord: chord!) * weighted.weight
            if (total > bestValue){
                best = weighted.chord
                bestValue = total
                conflicts.removeAll()
            } else if(total == bestValue){
                conflicts.append(weighted.chord)
            }
        }
        
        return best
        
    }
    
    
    private func calculateMappingValue(measure:[Note], chord:Chord) -> Double{
        var total = 0.0
        
        for note in measure{
            for value in chord.Values{
                if let baseNote = note.value{
                    if (baseNote%Scale.OCTAVE_LENGTH == value%Scale.OCTAVE_LENGTH){
                        total += note.length.rawValue
                    }
                }
                
            }
        }
        return total
    }
}
