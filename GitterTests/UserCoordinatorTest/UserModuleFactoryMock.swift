//
//  UserModuleFactoryMock.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import Foundation
@testable import Gitter

class UserModuleFactoryMock: UserModuleFactory {
    private let userController: UserController
    
    init(userController: UserController) {
        self.userController = userController
    }

    func makeUserModule() -> UserViewFlow {
        return userController
    }
}
