//
//  UserViewFlow.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

protocol UserViewFlow: BaseView {
    var onUserTapped: ((_ username: String?) -> Void)? { set get }
    func setUsername(_ username: String?)
}
