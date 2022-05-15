//
//  UserCoordinatorTests.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import XCTest

import XCTest
@testable import Gitter

class UserCoordinatorTests: XCTestCase {
    private var coordinator: Coordinator!
    private var router: RouterMock!
    
    private var userViewFlow: UserViewFlow!
    
    override func setUp() {
        super.setUp()
        router = RouterMockImp()
        let userController = UserController.controllerFromStoryboard(.user)
        let factory = UserModuleFactoryMock(userController: userController)
        
        coordinator = UserCoordinator(with: factory, router: router, coordinatorFactory: CoordinatorFactoryImp())
        userViewFlow = userController
        
    }
    
    override func tearDown() {
        coordinator = nil
        router = nil
        userViewFlow = nil
        super.tearDown()
    }
    
    func testStart() {
        coordinator.start("")
        XCTAssertTrue(router.navigationStack.first is UserController)
        XCTAssertTrue(router.navigationStack.count == 1)
    }
    
    func testShowUserFromUserView() {
        coordinator.start("")
        userViewFlow.onUserTapped?("")
        XCTAssertTrue(router.navigationStack.last is UserController)
        print(router.navigationStack.count)
        XCTAssertTrue(router.navigationStack.count == 1)

    }
}
