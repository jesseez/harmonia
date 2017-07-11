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
    let harmonyRoot = UInt8(48)
    var isPlaying = false
    var multiplier = 2
    
    //Outlets
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var restToggle: UIButton!
    @IBOutlet weak var musicDrawView: MusicDrawView!
    
    
    //Next ViewController
    var aboutView:UIViewController?
    
    let stylePicker = ["Classical", "Modern", "Minor Classical"]
    var styleNumber = 0
    
    var callback:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restToggle.isHidden = true
        playButton.isHidden = true
        //setTempoDisplay()
        //setBeatsPerMeasureDisplay()
        musicDrawView.initNoteBounds()
        
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

                let scale = Scale(root: root)
                
                var harmony = [Chord]()
                var melody = [Note]()
            
                switch styleNumber {
                case 0:
                    melody = NoteEventConverter.convertEvents(events: musicDrawView.noteEvents, tempo: (tempo*multiplier), scale: scale.getMajorScale())
                    
                    harmony = HarmonyFactory.generateClassicalHarmony(root: harmonyRoot, melody: melody, beatsPerMeasure: beatsPerMeasure)
                    
                case 1:
                    melody = NoteEventConverter.convertEvents(events: musicDrawView.noteEvents, tempo: (tempo*multiplier), scale: scale.getMajorScale())
                    
                    harmony = HarmonyFactory.generateModernHarmony(root: harmonyRoot, melody: melody, beatsPerMeasure: beatsPerMeasure)
                    
                case 2:
                    melody = NoteEventConverter.convertEvents(events: musicDrawView.noteEvents, tempo: (tempo*multiplier), scale: scale.getMinorScale())
                    
                    harmony = HarmonyFactory.generateMinorClassicalHarmony(root: harmonyRoot, melody: melody, beatsPerMeasure: beatsPerMeasure)
                    
                default:
                    print("you have an error with your style picker")
                }
            
                setValuesOnPlay()
                
            
                player.play(tempo: tempo, beatsPerMeasure: beatsPerMeasure, melody: melody, harmony: harmony, callback: callback!)
                
            }
        } else {
            player.stop()
            isPlaying = false
        }
    }
    
    func initCallback() -> (()->Void) {
        let callback:(() -> Void) = {
            self.recordButton.isHidden = false
            self.playButton.setTitle("Play", for: .normal)
//            self.tempoStepper.isEnabled = true
//            self.beatsPerMeasureStepper.isEnabled = true
        }
        return callback
    }
    
    func setValuesOnPlay(){
        playButton.setTitle("Stop", for: .normal)
        isPlaying = true
        self.recordButton.isHidden = true
//        self.tempoStepper.isEnabled = false
//        self.beatsPerMeasureStepper.isEnabled = false
    }
    
    func getConstraintSize()->Float{
        let screenSize: CGRect = UIScreen.main.bounds
        let size = Float(screenSize.height) / 10
        return size
    }
    
    @IBAction func toggleRecording(_ sender: UIButton) {
        if(!musicDrawView.isRecording){
            sender.setTitle("Stop", for: .normal)
            playButton.isHidden = true
            musicDrawView.startRecording()
            
        } else {
            sender.setTitle("Record", for: .normal)
            playButton.isHidden = false
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
    
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return stylePicker.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return stylePicker[row]
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        styleNumber = row
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        
//        let strTitle = stylePicker[row]
//        let attString = NSAttributedString(string: strTitle, attributes: [NSForegroundColorAttributeName : UIColor.white])
//        return attString
//    }

    
//    @IBAction func changeTempo(_ sender: UIStepper) {
//        tempo = Int(sender.value)
//        setTempoDisplay()
//    }

    
//    func setTempoDisplay(){
//        tempoDisplay.text = String(tempo)
//    }
    
    
//    @IBAction func changeBeatsPerMeasure(_ sender: UIStepper) {
//        beatsPerMeasure = sender.value
//        setBeatsPerMeasureDisplay()
//    }
    
//    func setBeatsPerMeasureDisplay(){
//        beatsPerMeasureDisplay.text = String(beatsPerMeasure)
//    }
    
    
    
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
         
         player.play(tempo: 120, beatsPerMeasure: 4, melody: melody, harmony: harmony)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

