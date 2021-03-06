//
//  CertificatePinningTests.swift
//  PeakNetwork
//
//  Created by Sam Oakley on 11/11/2016.
//  Copyright © 2016 3Squared. All rights reserved.
//

import Foundation
import XCTest
@testable import PeakNetwork

class CertificatePinningTests: XCTestCase {
    
    let api = MyAPI()

    func testNoCertificate() {
        let expect = expectation(description: "")
        
        let certificatePinningSessionDelegate = CertificatePinningSessionDelegate(bundle: .module)
        let urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: certificatePinningSessionDelegate,
                                    delegateQueue: nil)
        
        let networkOperation = NetworkOperation(resource: api.url(URL(string: "https://google.com")!), session: urlSession)
        
        networkOperation.addResultBlock { result in
            do {
                try _ = result.get()
                XCTFail()
            } catch {
                expect.fulfill()
            }
        }
        
        networkOperation.enqueue()
        
        waitForExpectations(timeout: 5)
    }
    
    
    func testValidCertificate() {
        let expect = expectation(description: "")
        
        let certificatePinningSessionDelegate = CertificatePinningSessionDelegate(bundle: .module)
        let urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                    delegate: certificatePinningSessionDelegate,
                                    delegateQueue: nil)
        
        let networkOperation = NetworkOperation(resource: api.url(URL(string: "https://github.com")!), session: urlSession)
        
        networkOperation.addResultBlock { result in
            do {
                try _ = result.get()
                expect.fulfill()
            } catch {
                XCTFail()
            }
        }
        
        networkOperation.enqueue()
        
        waitForExpectations(timeout: 5)
    }
}
