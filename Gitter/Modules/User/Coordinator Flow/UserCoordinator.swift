//
//  UserCoordinator.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

class UserCoordinator: BaseCoordinator {
    var finishFlow: (() -> Void)?
    
    private let factory: UserModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router

    init(with factory: UserModuleFactory, router: Router, coordinatorFactory: CoordinatorFactory) {
        self.factory = factory
        self.coordinatorFactory = coordinatorFactory
        self.router = router
    }
    
    override func start(_ username: String?) {
        showUserView(username: username)
    }
    
    private func showUserView(username: String?) {
        let module = factory.makeUserModule()
        module.setUsername(username)
        module.onUserTapped = {[weak self] username in
            self?._showUserView(username: username)
        }
        router.setRootModule(module)
    }
    
    private func _showUserView(username: String?) {
        let module = factory.makeUserModule()
        module.setUsername(username)
        module.onUserTapped = {[weak self] username in
            self?._showUserView(username: username)
        }
        router.show(module)
    }
}
