//
//  StringMockUsableTests.swift
//  InstantMock
//
//  Created by Patrick on 06/05/2017.
//  Copyright 2017 pirishd. All rights reserved.
//

import XCTest
@testable import InstantMock


final class StringMockUsableTests: XCTestCase {


    static var allTests = [
        ("testEqual_toNil", testEqual_toNil),
        ("testEqual_toWrongType", testEqual_toWrongType),
        ("testEqual_toWrongValue", testEqual_toWrongValue),
        ("testEqual_toExpectedValue", testEqual_toExpectedValue),
    ]


    func testEqual_toNil() {
        let ret = "any".equal(to: nil)
        XCTAssertFalse(ret)
    }


    func testEqual_toWrongType() {
        let ret = "any".equal(to: 12)
        XCTAssertFalse(ret)
    }


    func testEqual_toWrongValue() {
        let ret = "any".equal(to: "other")
        XCTAssertFalse(ret)
    }


    func testEqual_toExpectedValue() {
        let ret = "any".equal(to: "any")
        XCTAssertTrue(ret)
    }


}
