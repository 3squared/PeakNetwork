//
//  RecordingLoggerTests.swift
//  PeakNetwork-iOSTests
//
//  Created by Luke Stringer on 13/02/2019.
//  Copyright © 2019 3Squared. All rights reserved.
//

import Foundation

import XCTest

#if os(iOS)

@testable import PeakNetwork_iOS

#else

@testable import PeakNetwork_macOS

#endif

class RecordingLoggerTests: XCTestCase {
    
    func testProducesJSONFile() {
        let expect = expectation(description: "\(#function)")
        
        let request = URLRequest(url: URL(string:"https://api.3squared.com/path/to/method?first=string&second=true&third=0")!)
        let id = UUID()
        let requestDate = Date()
        let responseDate = Date()
        let jsonData = try! JSONSerialization.data(withJSONObject: ["name": "Peak", "type": "Network"], options: .prettyPrinted)
        
        let logger = RecordingJSONLogger(fileWriter: MockFileWriter { _, filename in
            XCTAssertEqual(filename, "api.3squared.com--path-to-method-first=string-second=true-third=0")
            expect.fulfill()
        })
        
        logger.log(id: id, requestDate: requestDate, request: request)
        logger.log(id: id, requestDate: requestDate, responseDate: responseDate, data: jsonData, response: nil, error: nil)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}


struct MockFileWriter: WriteFile {
    let callBack: (_ string: String, _ fileName: String) -> ()
    
    func write(_ string: String, toFileNamed filename: String) {
        callBack(string, filename)
    }
}

