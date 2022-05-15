//
//  BaseCoordinatorTest.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import XCTest
@testable import Gitter

class BaseCoordinatorTest: XCTestCase {
    
    var coordinator: BaseCoordinator!

    override func setUp() {
        super.setUp()
        coordinator = BaseCoordinator()
    }
    
    override func tearDown() {
        coordinator = nil
        super.tearDown()
    }
    
    func testCoordinatorArrayInitializedOfEmptyArray() {
        XCTAssertTrue(coordinator.childCoordinators.isEmpty)
    }
    
    func testCoordinatorAddDependency() {
        
        coordinator.addDependency(coordinator)
        XCTAssertTrue(coordinator.childCoordinators.first is BaseCoordinator)
        XCTAssertTrue(coordinator.childCoordinators.count == 1)
        coordinator.addDependency(coordinator)
        XCTAssertTrue(coordinator.childCoordinators.count == 1, "Only unique reference could be added")
        
        let newCoordinator = BaseCoordinator()
        coordinator.addDependency(newCoordinator)
        XCTAssertTrue(coordinator.childCoordinators.count == 2)
    }
    
    func testCoordinatorRemoveDependency() {
        
        coordinator.addDependency(coordinator)
        XCTAssertTrue(coordinator.childCoordinators.first is BaseCoordinator)
        coordinator.removeDependency(coordinator)
        XCTAssertTrue(coordinator.childCoordinators.isEmpty)
        coordinator.removeDependency(coordinator)
        XCTAssertTrue(coordinator.childCoordinators.isEmpty, "If we try to remove removed referense, crush can't happend")
    }
}
