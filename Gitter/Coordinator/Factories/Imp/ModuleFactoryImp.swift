//
//  ModuleFactoryImp.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

class ModuleFactoryImp {
    func makeSearchModule() -> SearchViewFlow {
        return SearchController.controllerFromStoryboard(.search)
    }
    
    func makeUserModule() -> UserViewFlow {
        return UserController.controllerFromStoryboard(.user)
    }
}

extension ModuleFactoryImp: SearchModuleFactory, UserModuleFactory {}
