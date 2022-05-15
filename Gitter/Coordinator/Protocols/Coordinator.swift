//
//  Coordinator.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
    func start(_ username: String?)
}
