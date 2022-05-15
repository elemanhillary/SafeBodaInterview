//
//  SearchModuleFactoryMock.swift
//  GitterTests
//
//  Created by MacBook Pro on 5/15/22.
//

import Foundation
@testable import Gitter

class SearchModuleFactoryMock: SearchModuleFactory {
    private let searchController: SearchController
    
    init(searchController: SearchController) {
        self.searchController = searchController
    }
    
    func makeSearchModule() -> SearchViewFlow {
        return searchController
    }
}
