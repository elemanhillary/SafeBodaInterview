//
//  UsersResponse.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation

class SearchUser: BaseModel {
    var total_count: Int?
    var incomplete_results: Bool?
    var items: [User]?
}

class User: BaseModel {
    var login: String?
    var id: Int?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var followers_url: String?
    var following_url: String?
    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var hireable: Bool?
    var bio: String?
    var twitter_username: String?
    var public_repos: Int?
    var public_gists: String?
    var followers: String?
    var following: String?
}
