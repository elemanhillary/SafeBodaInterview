//
//  CoordinatorFactory.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

protocol CoordinatorFactory {
    func makeSearchCoordinator() -> Coordinator
    func makeSearchCoordinator(router: Router) -> Coordinator & SearchCoordinatorOutput
    func makeSearchCoordinator(storyBoard: Storyboards) -> Coordinator
    
    func makeUserCoordinator() -> Coordinator
    func makeUserCoordinator(router: Router) -> Coordinator & UserCoordinatorOutput
    func makeUserCoordinator(storyBoard: Storyboards) -> Coordinator
    func makeUserCoordinator(storyBoard: Storyboards) -> (toPresent: Presentable?, Coordinator & UserCoordinatorOutput)
}
