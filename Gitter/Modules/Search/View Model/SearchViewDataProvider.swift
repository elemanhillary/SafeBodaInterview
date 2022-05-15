//
//  SearchViewDataProvider.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

class SearchViewDataProvider {
    var users = [User]()
    var search = [User]()
    var page: Int = 0
    var since: Int = 0
    var perPage: Int = 10
    
    func getUsers(completion: ((_ users: [User]?, _ error: Error?)->())?=nil) {
        UserRequest.getUsers(since: since, perPage: perPage, success: {[weak self] response, _ in
            if let response = response as? [User] {
                self?.users += response
                completion?(self?.users, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
    
    func searchUsers(query: String, completion: ((_ users: [User]?, _ error: Error?)->())?=nil) {
        UserRequest.searchUsers(page: page, query: query, success: { response, _ in
            if let response = response as? SearchUser {
                completion?(response.items, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
    
    func cacheFirstSearch(query: String) -> [User] {
        let users = users.filter { user -> Bool in
            if let login = user.login {
                if login.lowercased().contains(query.lowercased()) {
                    return true
                }
                return false
            }
            return false
        }
        return users
    }
}
