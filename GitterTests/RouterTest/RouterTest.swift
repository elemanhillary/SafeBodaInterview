//
//  RouterTest.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import XCTest
@testable import Gitter

class RouterTest: XCTestCase {
    
    private var router: RouterMock!
    
    private var firstController: UIViewController!
    private var secondController: UIViewController!
    
    override func setUp() {
        super.setUp()
        router = RouterMockImp()
        firstController = SearchController.controllerFromStoryboard(.search)
        secondController = UserController.controllerFromStoryboard(.user)
    }
    
    override func tearDown() {
        router = nil
        firstController = nil
        secondController = nil
        super.tearDown()
    }
    
    func testRouterSetRootModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.first is SearchController)
    }
    
    func testRouterPushViewModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.last is SearchController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is UserController)
    }
    
    func testRouterPopViewModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.last is SearchController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is UserController)
        
        router.popModule()
        XCTAssertTrue(router.navigationStack.last is SearchController)
    }
    
    func testRouterPopToRootViewModule() {
        router.setRootModule(firstController)
        XCTAssertTrue(router.navigationStack.last is SearchController)
        router.push(secondController)
        XCTAssertTrue(router.navigationStack.last is UserController)
        
        router.popToRootModule(animated: false)
        XCTAssertTrue(router.navigationStack.last is SearchController)
    }
    
    func testPresentViewModule() {
        router.present(secondController)
        XCTAssertTrue(router.presented is UserController)
    }
    
    func testDismissViewModule() {
        router.present(secondController)
        XCTAssertTrue(router.presented is UserController)
        router.dismissModule()
        XCTAssertTrue(router.presented == nil)
    }
}
