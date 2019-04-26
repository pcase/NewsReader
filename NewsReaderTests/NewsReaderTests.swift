//
//  NewsReaderTests.swift
//  NewsReaderTests
//
//  Created by Patty Case on 3/30/19.
//  Copyright © 2019 Azure Horse Creations. All rights reserved.
//

import XCTest
import Alamofire
import OHHTTPStubs

@testable import NewsReader

class NewsReaderTests: XCTestCase {

    var apiKey = "2624297672fe4e60b7d9316027ccec42"
    let API_URL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=2624297672fe4e60b7d9316027ccec42"
    var NRTvc: NewsReaderTableViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        NRTvc = storyboard.instantiateInitialViewController() as! NewsReaderTableViewController
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNumberOfTitles() {
        XCTAssertEqual(NRTvc.title?.count, nil, "Should be 0 titles")
        XCTAssertEqual(NRTvc.newsDataList.count, 0, "Should be 0 items in news data list")
    }
    
    func testGetNewsData() {
        guard let newsUrl = URL(string: API_URL) else { return }
        let promise = expectation(description: "Simple Request")
        URLSession.shared.dataTask(with: newsUrl) { (data, response, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let result = json as? NSDictionary {
                    if let articles = result as? NSDictionary {
                        if let title = articles["title"] as? String {
                            XCTAssert(title != nil)
                        }
                    }
                    promise.fulfill()
                }
            } catch let err {
                print("Error", err)
            }
            }.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
}

