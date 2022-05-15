//
//  SearchCoordinator.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

class SearchCoordinator: BaseCoordinator {
    var finishFlow: (() -> Void)?
    
    private let factory: SearchModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router

    init(with factory: SearchModuleFactory, router: Router, coordinatorFactory: CoordinatorFactory) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start() {
        showSearchView()
    }
    
    private func showSearchView() {
        let module = factory.makeSearchModule()
        module.onUserTapped = {[weak self] username in
            self?.showUserView(username: username)
        }
        router.setRootModule(module)
    }
    
    private func showUserView(username: String?) {
        var (module, coordinator) = coordinatorFactory.makeUserCoordinator(storyBoard: .user)
        coordinator.finishFlow = {[weak self, unowned coordinator] in
            self?.router.dismissModule()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        router.present(module)
        coordinator.start(username)
    }
}
