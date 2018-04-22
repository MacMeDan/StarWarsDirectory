//
//  PhoneNumberFormatersTest.swift
//  UnitTests
//
//  Created by Dan Leonard on 4/21/18.
//  Copyright © 2018 MacMeDan. All rights reserved.
//

import XCTest
@testable import StarWarsDirectory

class PhoneNumberFormatersTest: XCTestCase {
    
    var formatter: PhoneNumber!
    
    override func setUp() {
        super.setUp()
        formatter = PhoneNumber()
    }
    
    override func tearDown() {
        formatter = nil
        super.tearDown()
    }
    
    func testFormatter() {
        XCTAssertEqual(formatter.string(from: "8"), "8")
        XCTAssertEqual(formatter.string(from: "80"), "80")
        XCTAssertEqual(formatter.string(from: "801"), "801")
        XCTAssertEqual(formatter.string(from: "8015"), "801-5")
        XCTAssertEqual(formatter.string(from: "80155"), "801-55")
        XCTAssertEqual(formatter.string(from: "801555"), "801-555")
        XCTAssertEqual(formatter.string(from: "8015551"), "801-5551")
        XCTAssertEqual(formatter.string(from: "80155512"), "(801) 555-12")
        XCTAssertEqual(formatter.string(from: "801555123"), "(801) 555-123")
        XCTAssertEqual(formatter.string(from: "8015551234"), "(801) 555-1234")
        XCTAssertEqual(formatter.string(from: "18015551234"), "(801) 555-1234")
        XCTAssertEqual(formatter.string(from: "1801555123456"), "1801555123456")
    }
    
}
