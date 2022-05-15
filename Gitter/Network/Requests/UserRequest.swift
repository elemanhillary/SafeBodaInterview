//
//  UserRequest.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import Alamofire

private enum UserEndPoints: String {
    case users = "/users"
    case search = "/search/users"
}

class UserRequest: BaseRequest {
    var since: Int?
    var page: Int?
    var perPage: Int?
    var q: String?
    
    static func getUsers(since: Int, perPage: Int, success: @escaping  HttpSuccess, failure: @escaping  HttpFailure) {
        let request = UserRequest()
        /// github api uses since to paginate through a list of users
        request.since = since
        request.perPage = perPage
        BaseNetwork.shared.getRequest(urlPath: UserEndPoints.users.rawValue, headers: nil, request: request, encoding: URLEncoding.default, success: { data, code in
            if let response = [User].deserialize(from: data as? [Any]) {
                success(response, code)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func getUser(username: String, success: @escaping  HttpSuccess, failure: @escaping  HttpFailure) {
        let request = UserRequest()
        BaseNetwork.shared.getRequest(urlPath: "\(UserEndPoints.users.rawValue)/\(username)", headers: nil, request: request, encoding: URLEncoding.default, success: { data, code in
            if let response = User.deserialize(from: data as? [String: Any]) {
                success(response, code)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func searchUsers(page: Int, query: String, success: @escaping  HttpSuccess, failure: @escaping  HttpFailure) {
        let request = UserRequest()
        /// github api uses page to paginate through a list of users when searching
        request.page = page
        request.q = query
        BaseNetwork.shared.getRequest(urlPath: UserEndPoints.search.rawValue, headers: nil, request: request, encoding: URLEncoding.default, success: { data, code in
            if let response = SearchUser.deserialize(from: data as? [String: Any]) {
                success(response, code)
            }
        }, failure: { error in
            failure(error)
        })
    }
    
    static func getUserFollows(urlPath: String, perPage: Int, page: Int, success: @escaping  HttpSuccess, failure: @escaping  HttpFailure) {
        let request = UserRequest()
        request.perPage = perPage
        request.page = page
        BaseNetwork.shared.getRequest(urlPath: UserEndPoints.users.rawValue + urlPath, headers: nil, request: request, encoding: URLEncoding.default, success: { data, code in
            if let response = [User].deserialize(from: data as? [Any]) {
                success(response, code)
            }
        }, failure: { error in
            failure(error)
        })
    }
}
