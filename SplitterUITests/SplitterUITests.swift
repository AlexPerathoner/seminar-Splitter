//
//  SplitterUITests.swift
//  SplitterUITests
//
//  Created by Michael Berk on 3/23/20.
//  Copyright © 2020 Michael Berk. All rights reserved.
//

import XCTest
@testable import Splitter

class SplitterUITests: XCTestCase {
	
	var app: XCUIApplication!

	override func setUp() {
		// Put setup code here. This method is called before the invocation of each test method in the class.
		
		app = XCUIApplication()
		app.launch()
		
		
		
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
	
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
	
}

