//
//  GitterTests.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/14/22.
//

import XCTest
import Alamofire

@testable import Gitter


class GitterTests: XCTestCase {
    private var networkManager: NetworkReachabilityManager!
    
    override func setUp() {
        super.setUp()
        networkManager = BaseNetwork.reachabilityManager
    }
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    
    override func tearDown() {
        networkManager = nil
        super.tearDown()
    }
        
    func testUserListValidHttpCode200() throws {
        try XCTSkipUnless(networkManager.isReachable, "Active internet connection need for this")
        UserRequest.getUsers(since: 1, success: {[weak self] _, code in
            let promise = self?.expectation(description: "Status code 200")
            if code == 200 {
                promise?.fulfill()
            }
        }, failure: { error in
            XCTFail("Request failed with status code: \(error.asAFError?.responseCode ?? 400)")
        })
    }
    
    func testUserListRequestFail() throws {
        try XCTSkipUnless(networkManager.isReachable, "Active internet connection need for this")
        UserRequest.getUsers(since: -1001, success: {_, code in
        }, failure: { error in
            let error = error as NSError
            XCTAssertEqual(error.code, NetworkError.HttpRequestFailed.rawValue)
        })
    }
    
    func testGetUserValidHttpCode200() throws {
        try XCTSkipUnless(networkManager.isReachable, "Active internet connection need for this")
        UserRequest.getUser(username: usernamePassTest, success: {[weak self] _, code in
            let promise = self?.expectation(description: "Status code 200")
            if code == 200 {
                promise?.fulfill()
            }
        }, failure: { error in
            XCTFail("Request failed with status code: \(error.asAFError?.responseCode ?? 400)")
        })
    }
    
    func testGetUserRequestFail() throws {
        try XCTSkipUnless(networkManager.isReachable, "Active internet connection need for this")
        UserRequest.getUser(username: usernameFailTest, success: {_, code in
        }, failure: { error in
            let error = error as NSError
            XCTAssertEqual(error.code, NetworkError.HttpRequestFailed.rawValue)
        })
    }
    
    func testUserListModelDeserializing() throws {
        let user = [[
            "id": UUID().uuidString,
            "login": usernamePassTest
        ]]
        let userDeserialized = [User].deserialize(from: user)
        XCTAssertNotNil(userDeserialized)
    }
    
    func testUserModelDeserializing() throws {
        let user = [
            "id": UUID().uuidString,
            "login": usernamePassTest
        ]
        let userDeserialized = User.deserialize(from: user)
        XCTAssertNotNil(userDeserialized)
    }
}
