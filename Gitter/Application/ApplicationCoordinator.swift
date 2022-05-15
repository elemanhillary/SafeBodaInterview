//
//  ApplicationCoordinator.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

final class ApplicationCoordinator: BaseCoordinator {
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router

    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        runSearchFlow()
    }
    
    private func runSearchFlow() {
        var coordinator = coordinatorFactory.makeSearchCoordinator(router: router)
        coordinator.finishFlow = {[weak self, unowned coordinator] in
            self?.removeDependency(coordinator)
            self?.start()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
