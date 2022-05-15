//
//  UserViewDataProvider.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

class UserViewDataProvider {
    var user = User()
    var follows = [User]()
    var perPage = 10
    var page = 0
    
    func getUser(username: String, completion: ((_ user: User?, _ error: Error?)->())?=nil) {
        UserRequest.getUser(username: username, success: {[weak self] response, _ in
            if let response = response as? User {
                self?.user = response
                completion?(self?.user, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
    
    func getUserFollows(urlPath: String, completion: ((_ user: [User]?, _ error: Error?)->())?=nil) {
        UserRequest.getUserFollows(urlPath: urlPath, perPage: perPage, page: page, success: {[weak self] response, _ in
            if let response = response as? [User] {
                self?.follows = response
                completion?(self?.follows, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
}
