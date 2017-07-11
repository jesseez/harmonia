//
//  MelodyPlayer.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class MelodyPlayer : NSObject{
    
    var melodyPlayer = MidiPlayer(num: 64, drum: false)
    var harmonyPlayer = MidiPlayer(num: 49, drum: false)
    var tempo:Int?     //in beats per minute
    var beatsPerMeasure:Double?
    var melody:[Note]?
    var harmony:[Chord]?
    
    private var _stop = false
    
    private var tempoTime:TimeInterval?
    private var measureTime:TimeInterval?
    
    private var melodyIndex = 0
    private var harmonyIndex = 0
    
    private var melodyVolume = UInt8(90)
    private var harmonyVolume = UInt8(90)
    
    private var callback:(()->Void)?
    
    
    func stop(){
        _stop = true
        callback!()
    }
    
    func play(tempo:Int, beatsPerMeasure:Double, melody:[Note], harmony:[Chord]){
        _stop = false
        
        self.melody = melody
        self.harmony = harmony
        
        let second = TimeInterval(exactly: 1)
        let beatsPerSecond = Double(tempo) / 60.0
        
        self.tempoTime =  (second?.divided(by: beatsPerSecond))!
        self.measureTime = tempoTime?.multiplied(by: beatsPerMeasure)
        
        melodyIndex = 0
        harmonyIndex = 0
        
        var totalCounts = 0.0
        for i in melody{
            totalCounts += i.length.rawValue
        }
        
        playNextHarmony()
        
        //the Harmony takes a while to play, so we are going to delay the Melody
        let interval = TimeInterval(exactly: 0.125 )
        _ = Timer.scheduledTimer(timeInterval: interval!, target: self, selector: #selector(playNextMelody), userInfo: nil, repeats: false)
    }
    
    func play(tempo:Int, beatsPerMeasure:Double, melody:[Note], harmony:[Chord], callback:@escaping ()->Void){
        play(tempo: tempo, beatsPerMeasure: beatsPerMeasure, melody: melody, harmony: harmony)
        
        self.callback = callback
    }
    
    
    @objc private func playNextMelody(){
        //stop previous note
        if(melodyIndex > 0){
            if let lastNote = melody?[melodyIndex - 1].value{
                melodyPlayer.stopNote(note: lastNote)
            }
        }
        
        //play current note
        if(melodyIndex < (melody?.count)! && !_stop){
            let note = melody?[melodyIndex]
            if let noteValue = note?.value{
                melodyPlayer.playNote(pitch: noteValue, velocity: melodyVolume)
            }
        
        
            //set next event
            if(melodyIndex < (melody?.count)!){
                melodyIndex += 1
                let interval = tempoTime?.multiplied(by: (note?.length.rawValue)!)
                _ = Timer.scheduledTimer(timeInterval: interval!, target: self, selector: #selector(playNextMelody), userInfo: nil, repeats: false)

            }
        }
    }
    
    @objc private func playNextHarmony(){
        //stop previous note
        if(harmonyIndex > 0){
            let lastChord = harmony?[harmonyIndex - 1]
            harmonyPlayer.stopChord(chord: lastChord!)
        }
        
        //play current note
        if(harmonyIndex < (harmony?.count)! && !_stop){
            let chord = harmony?[harmonyIndex]
            harmonyPlayer.playChord(chord: chord!, velocity: harmonyVolume)
        
            
            //set next event
            if(harmonyIndex < (harmony?.count)!){
                harmonyIndex += 1
                _ = Timer.scheduledTimer(timeInterval: measureTime!, target: self, selector:     #selector(playNextHarmony), userInfo: nil, repeats: false)
            
            }
        } else if(!_stop){
            callback!()
        }
    }
    
}
