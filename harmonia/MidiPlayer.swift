//
//  MidiPlayer.swift
//  EpicMidiPlayer
//
//  Created by Jessee Zhang on 2/21/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation
import AVFoundation


class MidiPlayer: NSObject {
    
    private var engine:AVAudioEngine? // the most top level of the audio system - our sampler will 'connect' to this engine
    private var soundbank:URL? // this will reference a soundfont added to the app
    private var sampler:AVAudioUnitSampler? // see documentation also for AVAudioUnitMIDIInstrument
    
    
    private let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB) // an Apple provided variable to tell the sound font to use the pitched soundbank
    private let drumBank = UInt8(kAUSampler_DefaultPercussionBankMSB) // an Apple provided variable used to switch to percussion/drum soundbank
    
    let channel = UInt8(0);

    override init() { //initial setup of our MIDINote class to get the audioengine up and running and connected to our sampler that should use our font
        
        engine = AVAudioEngine() // 1. setup the audio engine so that we can everntually playback midi events via our soundfont
        
        soundbank = Bundle.main.url(forResource: "gs_instruments", withExtension: "dls") // 2. find out soundfont: using gs_instruments.dls located at /System/Library/Components/CoreAudio.component/Contents/Resources
        
        sampler = AVAudioUnitSampler()
        
        engine?.attach(sampler!)
        engine?.connect(sampler!, to: (engine?.mainMixerNode)!, format: nil)
        
        do {
            try engine?.start()
        } catch let error  {
            print(error.localizedDescription)
        }
    }
    
    init(num:Int, drum:Bool){
        //initial setup of our MIDINote class to get the audioengine up and running and connected to our sampler that should use our font
        
        engine = AVAudioEngine() // 1. setup the audio engine so that we can everntually playback midi events via our soundfont
        
        soundbank = Bundle.main.url(forResource: "gs_instruments", withExtension: "dls") // 2. find out soundfont: using gs_instruments.dls located at /System/Library/Components/CoreAudio.component/Contents/Resources
        
        sampler = AVAudioUnitSampler()
        
        engine?.attach(sampler!)
        engine?.connect(sampler!, to: (engine?.mainMixerNode)!, format: nil)
        
        do {
            try engine?.start()
        } catch let error  {
            print(error.localizedDescription)
        }
        
        let newPatch = UInt8(num)
        do {
            try sampler?.loadSoundBankInstrument(at: soundbank!, program: newPatch, bankMSB: melodicBank, bankLSB: 0)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func setPatch(num:Int, drum:Bool) { // to set a patch, provide a number (0-127) and true/false for drums
        let newPatch = UInt8(num)
        let bank = drum ? drumBank : melodicBank // let bank assigned by value of true/false from 'drum'
        
        do {
            try sampler?.loadSoundBankInstrument(at: soundbank!, program: newPatch, bankMSB: bank, bankLSB: 0)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playNote(pitch:UInt8, velocity:UInt8){
        sampler?.startNote(pitch, withVelocity: velocity, onChannel: channel)
    }
    
    func stopNote(note:UInt8){
        sampler?.stopNote(note, onChannel: channel)
    }
    
    func playChord(chord:Chord, velocity:UInt8){
        for note in chord.getChord(){
            playNote(pitch: note, velocity: velocity)
        }
    }
    
    func stopChord(chord:Chord){
        for note in chord.getChord(){
            stopNote(note: note)
        }
    }
}
