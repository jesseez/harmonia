//
//  MelodyDisplayView.swift
//  harmonia
//
//  Created by Jessee Zhang on 12/21/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation
import UIKit

class MelodyDisplayView : SegmentedView {
    
    private var isPlaying = false
    private var currentLineSegmentCount = 0
    private var lineSegments = [Line]()
    private var melody:[Note]?
    private var tempo:Int = 120
    private var scale:[UInt8]?
    private var twoOctaveScale:[UInt8]?
    
    private var framesPerSecond = 30
    private var timePerFrame:TimeInterval?
    private var framesPerBeat:Int = 0
    
    private var lineSegmentWidth:CGFloat = 0
    //unfortunately since i have so many points, it slows down the phone... so i gotta keep it short
    private var numSegmentsShown = 30
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        UIGraphicsBeginImageContext(self.frame.size)
        UIImage(named: "background")?.draw(in: self.bounds)
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(){
            UIGraphicsEndImageContext()
            self.backgroundColor = UIColor(patternImage: image)
        }else{
            UIGraphicsEndImageContext()
            debugPrint("Image not available")
        }
    }
    
    public func prepareMelody(melody:[Note], tempo:Int, scale:[UInt8]){
        
        self.melody = melody
        self.tempo = tempo
        self.scale = scale
        self.twoOctaveScale = convertScaleToTwoOctaves(scale: scale)
        self.timePerFrame = TimeInterval(exactly: 1)! / Double(framesPerSecond) 
        setFramesPerBeat()
        setLineSegmentWidth()
        

        self.lineSegments = createMelodyLine()
        
    }
    
    public func play(){
        resetValues()
        isPlaying = true
        Timer.scheduledTimer(timeInterval: TimeInterval(exactly: 0.125)!, target: self, selector: #selector(refreshMelodyLine), userInfo: nil, repeats: false)
    }
    
    public func stop(){
        isPlaying = false
    }
    
    private func convertScaleToTwoOctaves(scale:[UInt8]) -> [UInt8]{
        var upperScale = [UInt8]()
        for i in 1..<scale.count {
            upperScale.append(scale[i] + Scale.OCTAVE_LENGTH)
        }
        
        //apparently doing this is as good as making a shallow copy
        var newCopy = scale
        newCopy.append(contentsOf: upperScale)
        
        //reversed so that the higher notes are on top. it has to deal with the way we render the screen.
        //the logic in musicDrawView depends on that order
        return newCopy.reversed()
    }
    
    private func resetValues(){
        currentLineSegmentCount = 0
        numSegmentsShown = 30
    }
    
    private func getMelodyLength() -> Double{
        var length = 0.0
        for note in melody! {
            length = length + note.length.rawValue
        }
        
        return length
    }
    
    private func setFramesPerBeat() {
        // x frames per second
        // frames/second = beats/second * frames/beats
        // frames / beat = frames/second / beats/second = x / (tempo / 60) = x * 60 / tempo
        framesPerBeat = framesPerSecond * 60 / tempo
    }
    
    private func setLineSegmentWidth() {
        let melodyLength = getMelodyLength()
        let frames = ceil(Double(framesPerBeat) * melodyLength)
        
        lineSegmentWidth = CGFloat(Double(self.frame.width) / frames)
    }
    
    //create lines
    private func createMelodyLine() -> [Line] {
        var lineSegs = [Line]()
        var lastX = CGFloat(0)
        
        for i in 0..<melody!.count {
            let note = melody![i]
            
            if(note.value == nil){
                //if its nil, don't display anything. just show a gap
                let numFlatFrames = Int(round(note.length.rawValue * Double(framesPerBeat)))
                for _ in (1...numFlatFrames) {
                    lastX = lastX + lineSegmentWidth
                    lineSegs.append(Line(start: nil, end: nil))
                }
            } else {
                let y1 = getNoteBoundMiddle(note: note)!
                var lastPoint = CGPoint(x: lastX, y: y1)
                
                if(i == melody!.count-1 || melody![i+1].value == nil){
                    // since this is the last note, we don't need the transition
                    let numFlatFrames = Int(round(note.length.rawValue * Double(framesPerBeat)))
                    for _ in 1..<numFlatFrames{
                        lastX = lastX + lineSegmentWidth
                        let nextPoint = CGPoint(x: lastX, y: y1)
                        lineSegs.append(Line(start: lastPoint, end: nextPoint))
                        lastPoint = nextPoint
                    }
                    
                } else {
                    //flat
                    var numFlatFrames = Int(round((note.length.rawValue - 0.25) * Double(framesPerBeat)))
                    
                    if(i % 5 == 0){
                        //just trying to make the animation fit with the music better
                        numFlatFrames = numFlatFrames + 1
                    }
                    
                    for _ in 1..<numFlatFrames{
                        lastX = lastX + lineSegmentWidth
                        let nextPoint = CGPoint(x: lastX, y: y1)
                        lineSegs.append(Line(start: lastPoint, end: nextPoint))
                        lastPoint = nextPoint
                    }
                    
                    //transition
                    let numTransitionFrames = Int(round(0.25 * Double(framesPerBeat)))
                    let nextNote = melody![i+1]
                    let y2 = getNoteBoundMiddle(note: nextNote)!
                    let slope = (y2 - y1) / CGFloat(numTransitionFrames)
                    
                    for _ in 1...numTransitionFrames{
                        lastX = lastX + lineSegmentWidth
                        let nextPoint = CGPoint(x: lastX, y: (lastPoint.y + slope))
                        lineSegs.append(Line(start: lastPoint, end: nextPoint))
                        lastPoint = nextPoint
                    }
                    
                }

            }
        }
        
        return lineSegs
    }
    
    
    private func getNoteBoundMiddle(note:Note) -> CGFloat? {
        if let index = twoOctaveScale!.index(of: note.value!){
            return CGFloat(noteBounds![index].middleBound)
        }
        return nil
    }
    
    @objc private func refreshMelodyLine(){
        if(isPlaying && currentLineSegmentCount < lineSegments.count - 1){
            currentLineSegmentCount = currentLineSegmentCount + 1
            self.setNeedsDisplay()
            _ = Timer.scheduledTimer(timeInterval: timePerFrame!, target: self, selector: #selector(refreshMelodyLine), userInfo: nil, repeats: false)
        } else {
            decay()
        }
    }
    
    @objc private func decay(){
        if(numSegmentsShown > 0){
            numSegmentsShown = numSegmentsShown - 1
            self.setNeedsDisplay()
            _ = Timer.scheduledTimer(timeInterval: timePerFrame!, target: self, selector: #selector(decay), userInfo: nil, repeats: false)
        }
    }
    
    //draw
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        context?.setLineCap(CGLineCap.round)
        
        
        for line in lineSegments.prefix(currentLineSegmentCount).suffix(numSegmentsShown){
            if(line.start != nil && line.end != nil){
                context?.move(to: line.start!)
                context?.addLine(to: line.end!)
            }
        }
        
        context?.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 0.8)
        context?.setShadow(offset: CGSize(width:3, height:3), blur: 2)
        context?.setLineWidth(5)
        context?.strokePath()
        
    }
    
}
