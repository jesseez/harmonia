//
//  MelodyReaderTest.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/18/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import XCTest
@testable import harmonia

class MelodyReaderTest: XCTestCase {
    
    var melody:[Note] = []
    
    override func setUp() {
        super.setUp()
        
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedQuarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedHalf))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedHalf))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedHalf))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.dottedWhole))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedHalf))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.dottedQuarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedQuarter))
        melody.append(Note(value: 1, length: Length.whole))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedQuarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.dottedHalf))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.dottedQuarter))
        melody.append(Note(value: 1, length: Length.whole))
        melody.append(Note(value: 1, length: Length.half))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.doubleWhole))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.dottedQuarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.quarter))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.eighth))
        melody.append(Note(value: 1, length: Length.half))

        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetMeasure() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let reader = MelodyReader(melody: melody, beatsPerMeasure: 4)
        
        var count = 0
        while reader.hasNext(){
            let measure = reader.getNextMeasure()
            var measureLength = 0.0
            for note in measure{
                measureLength += note.length.rawValue
            }
            XCTAssertEqual(4.0, measureLength)
            count += 1
        }
        
        var total = 0.0
        for note in melody{
            total += note.length.rawValue
        }
        
        XCTAssertEqual(Int(ceil(total/4)), count)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
