//
//  Presentable.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
