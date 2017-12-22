//
//  ViewController.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AboutViewControllerDelegate{

    var tempo = 120
    var player = MelodyPlayer()
    var beatsPerMeasure = 4.0
    var root = UInt8(60)
    var scaleManager:Scale?
    var scale:[UInt8]?
    let harmonyRoot = UInt8(48)
    var isPlaying = false
    var multiplier = 2
    
    //Outlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var musicDrawView: MusicDrawView!
    @IBOutlet weak var melodyDisplayView: MelodyDisplayView!
    
    //Images
    let playImage = UIImage(named: "200 x 200 MusicPlay")
    let stopImage = UIImage(named: "200 x 200 StopButton")
    let recordImage = UIImage(named: "200 x 200 Record")
    let stopRecordImage = UIImage(named: "200 x 200 StopRecord")
    
    //Next ViewController
    var aboutView:UIViewController?
    
    let stylePicker = ["Classical", "Modern", "Minor Classical"]
    var styleNumber = 0
    
    var callback:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleManager = Scale(root:root)
        scale = scaleManager?.getMajorScale()
        musicDrawView.initNoteBounds()
        musicDrawView.setScale(scale: scale!)
        melodyDisplayView.initNoteBounds()
        
        playButton.isEnabled = false
        
        callback = initCallback()
    }

    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.portrait
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let next = segue.destination as! AboutViewController
        next.delegate = self
        
    }
    
    @IBAction func play(_ sender: UIButton) {
        if(!isPlaying){
            if(!musicDrawView.noteEvents.isEmpty){
                
                var harmony = [Chord]()
                let melody =  NoteEventConverter.convertEvents(events: musicDrawView.noteEvents, tempo: (tempo*multiplier), scale: scale!)
            
                switch styleNumber {
                case 0:
                    harmony = HarmonyFactory.generateClassicalHarmony(root: harmonyRoot, melody: melody, beatsPerMeasure: beatsPerMeasure)
                    
                case 1:
                    harmony = HarmonyFactory.generateModernHarmony(root: harmonyRoot, melody: melody, beatsPerMeasure: beatsPerMeasure)
                    
                case 2:
                    harmony = HarmonyFactory.generateMinorClassicalHarmony(root: harmonyRoot, melody: melody, beatsPerMeasure: beatsPerMeasure)
                    
                default:
                    print("you have an error with your style picker")
                }
            
                setValuesOnPlay()
                melodyDisplayView.prepareMelody(melody: melody, tempo: tempo, scale: scale!)
            
                player.play(tempo: tempo, beatsPerMeasure: beatsPerMeasure, melody: melody, harmony: harmony, callback: callback!)
                melodyDisplayView.play()
                
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            }
        } else {
            player.stop()
            melodyDisplayView.stop()
            isPlaying = false
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func initCallback() -> (()->Void) {
        let callback:(() -> Void) = {
            self.recordButton.isEnabled = true
            self.playButton.setImage(self.playImage, for: .normal)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        return callback
    }
    
    func setValuesOnPlay(){
        playButton.setImage(stopImage, for: .normal)
        isPlaying = true
        recordButton.isEnabled = false
    }
    
    func getConstraintSize()->Float{
        let screenSize: CGRect = UIScreen.main.bounds
        let size = Float(screenSize.height) / 10
        return size
    }
    
    @IBAction func toggleRecording(_ sender: UIButton) {
        if(!musicDrawView.isRecording){
            sender.setImage(stopRecordImage, for: .normal)
            playButton.isEnabled = false
            musicDrawView.startRecording()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            sender.setImage(recordImage, for: .normal)
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            if(musicDrawView.noteEvents.count > 0){
                playButton.isEnabled = true
            }
        }
        
        musicDrawView.isRecording = !musicDrawView.isRecording
    }
    
    @IBAction func togglePrependingRests(_ sender: UIButton) {
        if(musicDrawView.includeRestsAtBeginning){
            sender.setTitle("No Rests", for: .normal)
        } else {
            sender.setTitle("Rests", for: .normal)
        }
        
        musicDrawView.includeRestsAtBeginning = !musicDrawView.includeRestsAtBeginning
    }
    
    func setTempo(tempo:Int){
        self.tempo = tempo
    }
    
    func setBeatsPerMeasure(beatsPerMeasure:Double){
        self.beatsPerMeasure = beatsPerMeasure
    }
    
    func setStyleNumber(number:Int){
        self.styleNumber = number
        
        switch number {
            case 0:
                scale = scaleManager!.getMajorScale()
            case 1:
                scale = scaleManager!.getMajorScale()
            case 2:
                scale = scaleManager!.getMinorScale()
            default:
                print("you have an error with your style picker")
        }
        
        musicDrawView.setScale(scale: scale!)
    }
    
    func getInitialStyle() -> Int{
        return styleNumber
    }
    
    func getInitialTempo() -> Int{
        return tempo
    }
    
    func getInitialBeatsPerMeasure() -> Double{
        return beatsPerMeasure
    }
    
    
    //for testing purposes
    private func getMelody() -> [Note]{
        var melody = [Note]()
        
        let scale:Scale = Scale(root: 72)
        
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSeventh(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorSeventh(), length: Length.quarter))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.dottedQuarter))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.quarter))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.dottedQuarter))
        melody.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSeventh(), length: Length.eighth))

        
        
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSeventh(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorSixth(), length: Length.quarter))
        melody.append(Note(value: scale.getFifth(), length: Length.dottedQuarter))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.quarter))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.dottedQuarter))
        melody.append(Note(value: scale.getRoot(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSixth(), length: Length.eighth))

        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.dottedQuarter))
        melody.append(Note(value: scale.getMajorThird(), length: Length.quarter))
        melody.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSeventh(), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorSixth(), length: Length.dottedQuarter))
        melody.append(Note(value: scale.getFifth(), length: Length.quarter))
        melody.append(Note(value: scale.getFifth(), length: Length.eighth))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSeventh(), length: Length.eighth))

        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.half))
        melody.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getMajorThird(octave: 1), length: Length.eighth))
        melody.append(Note(value: scale.getFourth(octave: 1), length: Length.eighth))
        
        melody.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.half))



        
        
        return melody
    }
    
    private func testPlay(){
        var melody = getMelody()
        
        let scale:Scale = Scale(root: 72)
        
        var harmony = HarmonyFactory.generateModernHarmony(root: 48, melody: melody, beatsPerMeasure: 4)
         
        harmony.insert(Chord(), at: 0)
         
        melody.insert(Note(value: scale.getMajorSeventh(), length: Length.eighth), at: 0)
        melody.insert(Note(value: scale.getMajorSixth(), length: Length.eighth), at: 0)
        melody.insert(Note(value: scale.getMajorThird(), length: Length.eighth), at: 0)
        melody.insert(Note(value: nil, length: Length.eighth), at: 0)
        melody.insert(Note(value: nil, length: Length.half), at: 0)
         
        player.play(tempo: 120, beatsPerMeasure: 4, melody: melody, harmony: harmony, callback: callback!)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

