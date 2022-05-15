//
//  CoordinatorFactoryImp.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import UIKit

class CoordinatorFactoryImp {
    func makeSearchCoordinator() -> Coordinator {
        makeSearchCoordinator(storyBoard: .search)
    }
    
    func makeSearchCoordinator(router: Router) -> Coordinator & SearchCoordinatorOutput {
        return SearchCoordinator(with: ModuleFactoryImp(), router: router, coordinatorFactory: CoordinatorFactoryImp())
    }
    
    func makeSearchCoordinator(storyBoard: Storyboards) -> Coordinator {
        return SearchCoordinator(with: ModuleFactoryImp(), router: router(storyBoard), coordinatorFactory: CoordinatorFactoryImp())
    }
    
    func makeUserCoordinator() -> Coordinator {
        makeUserCoordinator(storyBoard: .search)
    }
    
    func makeUserCoordinator(router: Router) -> Coordinator & UserCoordinatorOutput {
        return UserCoordinator(with: ModuleFactoryImp(), router: router, coordinatorFactory: CoordinatorFactoryImp())
    }
    
    func makeUserCoordinator(storyBoard: Storyboards) -> Coordinator {
        return UserCoordinator(with: ModuleFactoryImp(), router: router(storyBoard), coordinatorFactory: CoordinatorFactoryImp())
    }
    
    func makeUserCoordinator(storyBoard: Storyboards) -> (toPresent: Presentable?, Coordinator & UserCoordinatorOutput) {
        let router = router(storyBoard)
        let coordinator = UserCoordinator(with: ModuleFactoryImp(), router: router, coordinatorFactory: CoordinatorFactoryImp())
        return (router, coordinator)
    }
    
    private func router(_ storyBoard: Storyboards) -> Router {
        return RouterImp(rootController: navigationController(storyBoard))
    }

    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImp(rootController: navigationController(navController))
    }

    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController {
            return navController
        } else {
            return UINavigationController.controllerFromStoryboard(.search)
        }
    }
    
    private func navigationController(_ storyBoard: Storyboards) -> UINavigationController {
        switch storyBoard {
        case .search:
            return UINavigationController.controllerFromStoryboard(.search)
        case .user:
            return UINavigationController.controllerFromStoryboard(.user)
        }
    }
}

extension CoordinatorFactoryImp: CoordinatorFactory {}
