//
//  TestApiRequestTests.swift
//  TestApiRequestTests
//
//  Created by Artem Kolyadin on 08.06.2018.
//  Copyright © 2018 Artem Kolyadin. All rights reserved.
//

import XCTest

class TestApiRequestTests: XCTestCase {
    var sessionUnderTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testValidCallToAPIGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://rest.bandsintown.com/artists/eminem?app_id=test")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }
    
}
