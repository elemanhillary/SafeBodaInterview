//
//  ConfigurableCells.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

protocol ConfigurableCells: AnyObject {
    associatedtype DataType
    static var reuseIdentifier: String { get }
    func build(with data: DataType)
}
