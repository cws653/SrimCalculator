//
//  SrimCalculatorTests.swift
//  SrimCalculatorTests
//
//  Created by 최원석 on 2020/12/05.
//  Copyright © 2020 최원석. All rights reserved.
//

import XCTest
@testable import SrimCalculator

class SrimCalculatorTests: XCTestCase {
    
    let operatorManager = OperatorManager()

    func testOperator() {
        var result: String?
        
        do {
            result = try operatorManager.roundToBillion(value: 100000000)
            XCTAssertTrue(result == "1")
            
            result = try operatorManager.roundToBillion(value: 200000000)
            XCTAssertTrue(result == "2")
            
            result = try operatorManager.roundToBillion(value: 10000000)
            XCTAssertTrue(result == nil)
            
            result = try operatorManager.roundToBillion(value: -100000)
            XCTAssertTrue(result == nil)
        
        } catch {
            print("123123123")
        }
    }

}
