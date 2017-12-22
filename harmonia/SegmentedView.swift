//
//  SegmentedView.swift
//  harmonia
//
//  Created by Jessee Zhang on 12/21/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation
import UIKit

//for lack of an abstract class, I don't know how to properly do this
class SegmentedView : UIView {
    
    var noteBounds:[NoteBound]?
    
    public func initNoteBounds(){
        
        if(noteBounds != nil){
            return
        }
        
        let realEstate = Double(self.frame.height)
        
        let noteBoundHeight = realEstate / 16
        
        var bounds = [NoteBound]()
        
        //NOTE: ORDER IS IMPORTANT
        
        var currentHeight = 0.0
        bounds.append(NoteBound(note: 14, upperBound: nil, middleBound: currentHeight + noteBoundHeight/2 ,lowerBound: currentHeight + noteBoundHeight))
        
        currentHeight += noteBoundHeight
        
        //Add the top values (minus the first because that doesn't have an upper bound
        for i in (8...13).reversed(){
            bounds.append(NoteBound(note: UInt8(i), upperBound: currentHeight, middleBound: currentHeight + noteBoundHeight/2, lowerBound: currentHeight + noteBoundHeight))
            
            currentHeight += noteBoundHeight
        }
        
        
        //Root takes up twice as much space just cuz
        bounds.append(NoteBound(note: UInt8(7), upperBound: currentHeight, middleBound: currentHeight + noteBoundHeight, lowerBound: currentHeight + (2 * noteBoundHeight)))
        
        
        currentHeight += (2 * noteBoundHeight)
        
        //Add the bottom values (minus the last because that doesn't have a lower bound
        for i in (1...6).reversed(){
            bounds.append(NoteBound(note: UInt8(i), upperBound: currentHeight, middleBound: currentHeight + noteBoundHeight/2, lowerBound: currentHeight + noteBoundHeight))
            
            currentHeight += noteBoundHeight
        }
        
        
        //Add the last value with no bottom bound
        bounds.append(NoteBound(note: 0, upperBound: currentHeight, middleBound: currentHeight + noteBoundHeight/2, lowerBound: nil))
        
        
        noteBounds = bounds
    }
    
}
