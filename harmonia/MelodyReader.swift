//
//  NoteReader.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class MelodyReader : NSObject{
    
    let melody:[Note]
    let beatsPerMeasure:Double
    private var currentIndex = 0
    private var leftover = 0.0
    
    var measuresMade = 0
    
    init(melody:[Note], beatsPerMeasure:Double) {
        self.melody = melody
        self.beatsPerMeasure = beatsPerMeasure
    }
    
    public func getNextMeasure() -> [Note]{
        var measure = [Note]()
        var totalDuration = 0.0
        
        if(leftover > 0){
            let first:Note
            let note = melody[currentIndex]
            
            totalDuration += leftover
            
            if(leftover <= beatsPerMeasure){
                first = Note(value: note.value, length: Length.get(length: leftover)!)
                leftover = 0
            } else {
                first = Note(value: note.value, length: Length.get(length: beatsPerMeasure)!)
            }
            measure.append(first)
            currentIndex += 1
        }
        
        while(totalDuration < beatsPerMeasure && currentIndex < melody.count){
            let note = melody[currentIndex]
            let prevTotal = totalDuration
            totalDuration += note.length.rawValue
            
            if(totalDuration > beatsPerMeasure){
                let last = Note(value: note.value, length: Length.get(length: beatsPerMeasure - prevTotal)!)
                measure.append(last)
            } else {
                measure.append(note)
            }
            
            currentIndex += 1
        }
        
        if(totalDuration > beatsPerMeasure){
            //this is in case we have notes held across measures
            //we will want to continue to consider this note
            currentIndex -= 1
            leftover = totalDuration - beatsPerMeasure
        } else if(totalDuration < beatsPerMeasure){
            measure.append(Note(value: nil, length: Length.get(length: beatsPerMeasure - totalDuration)!))
        } else {
            leftover = 0
        }
        
        measuresMade += 1
        return measure
    }
    
    public func hasNext() -> Bool {
        
        if(currentIndex < melody.count){
            return true
        }
        
        return false
    }
}
