//
//  SearchModuleFactory.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

protocol SearchModuleFactory {
    func makeSearchModule() -> SearchViewFlow
}
