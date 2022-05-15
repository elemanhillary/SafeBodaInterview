//
//  SearchCoordinatorTest.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import XCTest
@testable import Gitter

class SearchCoordinatorTest: XCTestCase {
    private var searchCoordinator: Coordinator!
    private var userCoordinator: Coordinator!
    private var router: RouterMock!
    
    private var searchViewFlow: SearchViewFlow!
    private var userViewFlow: UserViewFlow!
    
    override func setUp() {
        super.setUp()
        router = RouterMockImp()
        let searchController = SearchController.controllerFromStoryboard(.search)
        let searchFactory = SearchModuleFactoryMock(searchController: searchController)
        
        let userController = UserController.controllerFromStoryboard(.user)
        let userFactory = UserModuleFactoryMock(userController: userController)
        
        userCoordinator = UserCoordinator(with: userFactory, router: router, coordinatorFactory: CoordinatorFactoryImp())
        userViewFlow = userController
        
        searchCoordinator = SearchCoordinator(with: searchFactory, router: router, coordinatorFactory: CoordinatorFactoryImp())
        searchViewFlow = searchController
        
    }
    
    override func tearDown() {
        searchCoordinator = nil
        userCoordinator = nil
        router = nil
        searchViewFlow = nil
        super.tearDown()
    }
    
    func testStart() {
        searchCoordinator.start()
        XCTAssertTrue(router.navigationStack.first is SearchController)
        XCTAssertTrue(router.navigationStack.count == 1)
    }
    
    func testShowUser() {
        searchCoordinator.start()
        searchViewFlow.onUserTapped?("")
        XCTAssertTrue(router.navigationStack.last is SearchController)
        XCTAssertTrue(router.navigationStack.count == 1)

    }
}


