//
//  Line.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/25/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import UIKit

class Line : NSObject{
    
    var start:CGPoint?
    var end:CGPoint?
    
    init(start:CGPoint?, end:CGPoint?){
        self.start = start
        self.end = end
    }
}
