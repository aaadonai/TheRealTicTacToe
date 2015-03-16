//
//  TheRealTicTacToeTests.swift
//  TheRealTicTacToeTests
//
//  Created by Antonio Rodrigues on 15/03/2015.
//  Copyright (c) 2015 Antonio Rodrigues. All rights reserved.
//

import UIKit
import XCTest

class TheRealTicTacToeTests: XCTestCase {
    
    var engine:PerfectPlayer!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        engine = PerfectPlayer.init(state: BoardState())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testEngine() {
        
        //This is a perfect game, two perfect players playing against each other. 
        //It can only result in draw
        var m1: AnyObject? = engine.moveFromSearch(9)
        
        engine.performMove(m1!)
        
        var m2: AnyObject? = engine.moveFromSearch(8)
        
        engine.performMove(m2!)

        var m3: AnyObject? = engine.moveFromSearch(7)
        
        engine.performMove(m3!)

        var m4: AnyObject? = engine.moveFromSearch(6)
        
        engine.performMove(m4!)

        var m5: AnyObject? = engine.moveFromSearch(5)
        
        engine.performMove(m5!)

        var m6: AnyObject? = engine.moveFromSearch(4)
        
        engine.performMove(m6!)

        var m7: AnyObject? = engine.moveFromSearch(3)
        
        engine.performMove(m7!)
        
        var m8: AnyObject? = engine.moveFromSearch(2)
        
        engine.performMove(m8!)
        
        XCTAssertFalse(engine.isGameOver(), "false")

        var m9: AnyObject? = engine.moveFromSearch(1)
        
        engine.performMove(m9!)

        
        XCTAssertTrue(engine.isGameOver(), "true")
        
        var state = engine.currentState()
        
        XCTAssertTrue(state.isDraw(), "true")
    }
    
}
