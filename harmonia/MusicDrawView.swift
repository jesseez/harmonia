//
//  MusicDrawView.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/25/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import UIKit

class MusicDrawView : UIView{
    
    

    
    let octaveLength = UInt8(12)
    var scale:Scale = Scale(root: 72)
    var timer = Stopwatch()
    var noteBounds:[NoteBound]?
    
    var noteEvents = [NoteEvent]()
    private var currentEvent:NoteEvent?
    
    private var currentNoteBound:NoteBound? = nil
    private var currentBoundIndex = 0
    
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
            }
        }
        
        if let lower = currentNoteBound?.lowerBound{
            if(y > lower){
                
                endCurrentEvent()
                
                currentBoundIndex += 1
                currentNoteBound = noteBounds?[currentBoundIndex]
                
                currentEvent = NoteEvent(note: currentNoteBound?.note)
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
        
        //diminish drawing
        
        if(lines.count > 0){
            lines = Array(lines.suffix(20))
            diminishLine()
        }
    }
    
    
    @objc private func diminishLine(){
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
    
    public func initNoteBounds(){
        
        if(noteBounds != nil){
            return
        }
        
        let realEstate = Double(self.frame.height)
        
        let noteBoundHeight = realEstate / 16
        
        var bounds = [NoteBound]()
        
        //NOTE: ORDER IS IMPORTANT
        
        var currentHeight = 0.0
        bounds.append(NoteBound(note: 14, upperBound: nil, lowerBound: currentHeight + noteBoundHeight))
        
        currentHeight += noteBoundHeight
        
        //Add the top values (minus the first because that doesn't have an upper bound
        for i in (8...13).reversed(){
            bounds.append(NoteBound(note: UInt8(i), upperBound: currentHeight, lowerBound: currentHeight + noteBoundHeight))
            
            currentHeight += noteBoundHeight
        }
        
        
        //Root takes up twice as much space just cuz
        bounds.append(NoteBound(note: UInt8(7), upperBound: currentHeight, lowerBound: currentHeight + (2 * noteBoundHeight)))
        
        
        currentHeight += (2 * noteBoundHeight)
        
        //Add the bottom values (minus the last because that doesn't have a lower bound
        for i in (1...6).reversed(){
            bounds.append(NoteBound(note: UInt8(i), upperBound: currentHeight, lowerBound: currentHeight + noteBoundHeight))
            
            currentHeight += noteBoundHeight
        }
        
        
        //Add the last value with no bottom bound
        bounds.append(NoteBound(note: 0, upperBound: currentHeight, lowerBound: nil))
        
        
        noteBounds = bounds
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
