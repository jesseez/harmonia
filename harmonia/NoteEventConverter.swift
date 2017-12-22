//
//  NoteEventConverter.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/21/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class NoteEventConverter : NSObject{
    
    public static func convertEvents(events:[NoteEvent], tempo:Int, scale:[UInt8]) -> [Note]{
        
        //sorry, there doesn't seem to be a good way to do this
        
        let second = TimeInterval(exactly: 1)
        let beatsPerSecond = Double(tempo) / 60.0
        let tempoTime:TimeInterval = second! / beatsPerSecond

        let doubleWhole = tempoTime * 8
        let dottedWhole = tempoTime * 6
        let whole = tempoTime * 4
        let dottedHalf = tempoTime * 3
        let half = tempoTime * 2
        let dottedQuarter = tempoTime * 1.5
        let quarter = tempoTime
        let eighth = tempoTime / 2
        
        var melody = [Note]()
        
        for event in events{
            
            let length = event.length!
            
            let note = getNoteByIndex(index: event.note, scale: scale)
            
            if(melody.isEmpty && event.note == nil){
                //we don't want to do anything here. We don't want rests at the begining
            }
            else if(length >= doubleWhole || isCloserToFirst(length: length, first: doubleWhole, second: dottedWhole))
            {
                melody.append(Note(value: note, length: Length.doubleWhole))
            }
            else if(isCloserToFirst(length: length, first: dottedWhole, second: whole))
            {
                melody.append(Note(value: note, length: Length.dottedWhole))
            }
            else if(isCloserToFirst(length: length, first: whole, second: dottedHalf))
            {
                melody.append(Note(value: note, length: Length.whole))
            }
            else if(isCloserToFirst(length: length, first: dottedHalf, second: half))
            {
                melody.append(Note(value: note, length: Length.dottedHalf))
            }
            else if(isCloserToFirst(length: length, first: half, second: dottedQuarter))
            {
                melody.append(Note(value: note, length: Length.half))
            }
            else if(isCloserToFirst(length: length, first: dottedQuarter, second: quarter))
            {
                melody.append(Note(value: note, length: Length.dottedQuarter))
            }
            else if(isCloserToFirst(length: length, first: quarter, second: eighth))
            {
                melody.append(Note(value: note, length: Length.quarter))
            }
            else if(isCloserToFirst(length: length, first: eighth, second: 0.0))
            {
                melody.append(Note(value: note, length: Length.eighth))
            }
        }
        
        return melody
        
    }
    
    private static func isCloserToFirst(length:TimeInterval, first:TimeInterval, second:TimeInterval) -> Bool{
        if(abs(length - first) < abs(length - second))
        {
            return true
        }
        return false
    }
    
    private static func getNoteByIndex(index:UInt8?, scale:[UInt8]) -> UInt8? {
        let magicIndex = 7 //Based on the logic, 7 is the length of an octave-1 to accomodate for the index
        
        if(index == nil){
            return nil
        } else {
            let octaveChange = Int(floor(Double(index!)/Double(magicIndex)))
            let distance = octaveChange * Int(Scale.OCTAVE_LENGTH)
            
            return scale[Int(index!)%magicIndex] + UInt8(distance)
        }
    }
}
