//
//  NSObject+.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
