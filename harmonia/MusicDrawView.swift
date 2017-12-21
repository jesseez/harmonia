//
//  MusicDrawView.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/25/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import UIKit

class MusicDrawView : SegmentedView {
    
    let octaveLength = UInt8(12)
    var scale:[UInt8]?
    var player = MidiPlayer(num: 64, drum: false)
    var timer = Stopwatch()
    
    var noteEvents = [NoteEvent]()
    private var currentEvent:NoteEvent?
    
    private var currentNoteBound:NoteBound? = nil
    private var currentBoundIndex = 0
    
    var currentNote:UInt8?
    
    var isRecording = false
    var includeRestsAtBeginning = true
    
    
    var currentPoint:CGPoint?
    var lines = [Line]()
    
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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(!isRecording){
            return
        }
        
        if(currentEvent != nil){
            endCurrentEvent()
        } else{
            timer.start()
        }
        
        let point = touches.first?.location(in: self)
        currentPoint = point
        
        let height = Double((point?.y)!)
        
        currentNoteBound = getBound(height: height)
        
        if(currentNoteBound != nil){
            currentBoundIndex = (noteBounds?.index(of: currentNoteBound!))!
        
            currentEvent = NoteEvent(note: currentNoteBound?.note)
            
            currentNote = getNoteByIndex(index: currentNoteBound?.note)
            tryPlayNote()
            
        
            self.setNeedsDisplay()
        }
    }
    
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(!isRecording){
            return
        }
        
        let point = touches.first?.location(in: self)
        lines.append(Line(start: currentPoint!, end: point!))
        currentPoint = point
        
        let y = Double((touches.first?.location(in: self).y)!)
        
        if let upper = currentNoteBound?.upperBound{
            //top is 0
            if(y < upper){
                
                endCurrentEvent()
                
                currentBoundIndex -= 1
                currentNoteBound = noteBounds?[currentBoundIndex]
                
                currentEvent = NoteEvent(note: currentNoteBound?.note)
                
                tryStopNote()
                currentNote = getNoteByIndex(index: currentNoteBound?.note)
                tryPlayNote()
                
            }
        }
        
        if let lower = currentNoteBound?.lowerBound{
            if(y > lower){
                
                endCurrentEvent()
                
                currentBoundIndex += 1
                currentNoteBound = noteBounds?[currentBoundIndex]
                
                currentEvent = NoteEvent(note: currentNoteBound?.note)
                
                tryStopNote()
                currentNote = getNoteByIndex(index: currentNoteBound?.note)
                tryPlayNote()
                
            }
        }
        
        self.setNeedsDisplay()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!isRecording){
            return
        }
        
        endCurrentEvent()
        
        currentEvent = NoteEvent(note: nil)
        
        currentNoteBound = nil
        
        tryStopNote()
        
        //diminish drawing
        
        if(lines.count > 0){
            lines = Array(lines.suffix(20))
            diminishLine()
        }
    }
    
    public func setScale(scale: [UInt8]) {
        self.scale = scale
    }
    
    func tryPlayNote(){
        if(currentNote != nil){
            player.playNote(pitch: currentNote!, velocity: UInt8(90))
        }
    }
    
    func tryStopNote(){
        if(currentNote != nil){
            player.stopNote(note: currentNote!)
        }
    }
    
    private func getNoteByIndex(index:UInt8?) -> UInt8? {
        let magicIndex = 7 //Based on the logic, 7 is the length of an octave-1 to accomodate for the index
        
        if(index == nil){
            return nil
        } else {
            let octaveChange = Int(floor(Double(index!)/Double(magicIndex)))
            let distance = octaveChange * Int(Scale.OCTAVE_LENGTH)
            
            return scale![Int(index!)%magicIndex] + UInt8(distance)
        }
    }
    
    @objc private func diminishLine() {
        if(lines.count > 0){
            lines.remove(at: 0)
        }
        
        if(lines.count > 0){
            let interval = TimeInterval(exactly: 0.01)
            _ = Timer.scheduledTimer(timeInterval: interval!, target: self, selector: #selector(diminishLine), userInfo: nil, repeats: false)
        }
        
        
        self.setNeedsDisplay()
    }
    
    func getBound(height:Double) -> NoteBound?{
        
        for bound in noteBounds!{
            
            var isAboveLowerBound = true
            if let lower = bound.lowerBound{
                //0 is at the top
                isAboveLowerBound = (height < lower)
            }
            
            var isBelowUpperBound = true
            if let upper = bound.upperBound{
                isBelowUpperBound = (height > upper)
            }
            
            if(isAboveLowerBound && isBelowUpperBound){
                return bound
            }
        }
        
        return nil
    }
    
    public func startRecording(){
        clearNoteEvents()
        if(includeRestsAtBeginning){
            timer.start()
            currentEvent = NoteEvent(note: nil)
        }
    }
    
    public func stopRecording(){
        endCurrentEvent()
    }
    
    public func clearNoteEvents(){
        noteEvents.removeAll()
    }
    
    func endCurrentEvent(){
        currentEvent?.length = timer.getElapsedTime()
        noteEvents.append(currentEvent!)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        
        context?.setLineCap(CGLineCap.round)
        
        
        for line in lines.suffix(20){
            context?.move(to: line.start)
            context?.addLine(to: line.end)
        }
        
        context?.setStrokeColor(red: 0, green: 0.3, blue: 1, alpha: 0.8)
        context?.setShadow(offset: CGSize(width:3, height:3), blur: 2)
        context?.setLineWidth(5)
        context?.strokePath()
        
    }
    
}
