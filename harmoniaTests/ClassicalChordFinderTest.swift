//
//  ClassicalChordFinderTest.swift
//  harmonia
//
//  Created by Jessee Zhang on 4/20/17.
//  Copyright © 2017 Jessee Zhang. All rights reserved.
//

import XCTest
@testable import harmonia

class ClassicalChordFinderTest: XCTestCase {
    
    var chordFinder:ChordFinder? = nil
    var scale = Scale(root: 60)
    
    override func setUp() {
        super.setUp()
        
        chordFinder = ClassicalChordFinder(root: 60)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMeasureOne() {
        var measure = [Note]()
        measure.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        measure.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        measure.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        measure.append(Note(value: scale.getMajorSeventh(), length: Length.eighth))
        measure.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        measure.append(Note(value: scale.getMajorThird(), length: Length.eighth))
        measure.append(Note(value: scale.getMajorSixth(), length: Length.eighth))
        measure.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        
        let type = chordFinder!.findChord(measure: measure)
        
        XCTAssertEqual(CoreChord.vi, type)
    }
    
    func testMeasureTwo() {
        var measure = [Note]()
        measure.append(Note(value: scale.getMajorSeventh(), length: Length.quarter))
        measure.append(Note(value: scale.getMajorSixth(), length: Length.dottedQuarter))
        measure.append(Note(value: scale.getFifth(), length: Length.eighth))
        measure.append(Note(value: scale.getRoot(octave: 1), length: Length.eighth))
        measure.append(Note(value: scale.getMajorSecond(octave: 1), length: Length.eighth))
        
        let type = chordFinder!.findChord(measure: measure, previous: CoreChord.vi)
        
        XCTAssertEqual(CoreChord.ii, type)
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
