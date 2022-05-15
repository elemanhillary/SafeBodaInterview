//
//  SearchViewFlow.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

protocol SearchViewFlow: BaseView {
    var onUserTapped: ((_ username: String?) -> Void)? { set get }
}
