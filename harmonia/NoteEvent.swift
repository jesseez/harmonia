//
//  NoteEvent.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import Foundation

class NoteEvent : NSObject {
    
    let note:UInt8?
    var length:TimeInterval?
    
    init(note:UInt8?){
        self.note = note
    }
    
}
