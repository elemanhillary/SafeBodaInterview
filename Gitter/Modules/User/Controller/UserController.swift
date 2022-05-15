//
//  UserController.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import UIKit

class UserController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var onUserTapped: ((String?) -> Void)?
    
    private var userListProvider = UserViewDataProvider()
    private var userListDataSource = UserViewDataSource()
    private enum ActiveTabEnum: Int {
        case followers = 0, following
    }
    private var activeTab: ActiveTabEnum = .followers
    
    var username: String = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.dataSource = userListDataSource
        tableView.delegate = userListDataSource
        tableView.register(HeaderCell.self, TabCell.self, UserCell.self)
        
        /// Fetch more if user has more `followers, followings`
        /// userListDataSource.onFetchMore = {[weak self] in
        ///    guard let `self` = self else { return }
        ///    switch self.activeTab {
        ///    case .following:
        ///        self.getUserFollowsBy(urlPath: "/\(self.username)/following")
        ///    case .followers:
        ///        self.getUserFollowsBy(urlPath: "/\(self.username)/followers")
        ///    }
        /// }
        
        /// `Fetch followers` on tap followers tab
        userListDataSource.onTappedFollowers = {[weak self] in
            guard let `self` = self else { return }
            self.activeTab = .followers
            self.userListProvider.page = 1
            self.getUserFollowsBy(urlPath: "/\(self.username)/followers")
        }
        
        /// `Fetch followings` on tap following tab
        userListDataSource.onTappedFollowing = {[weak self] in
            guard let `self` = self else { return }
            self.userListProvider.page = 1
            self.activeTab = .following
            self.getUserFollowsBy(urlPath: "/\(self.username)/following")
        }
        
        userListDataSource.onUserTapped = {[weak self] username in
            self?.onUserTapped?(username)
        }
        
        getUser(username)
        getUserFollowsBy(urlPath: "/\(username)/followers")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = username
    }
    
    func getUser(_ username: String) {
        userListProvider.getUser(username: username, completion: {[weak self] (user, error) in
            guard let `self` = self else { return }
            guard error == nil else {
                return
            }
            guard let user = user else { return }
            self.userListDataSource.updateList(user)
            self.userListDataSource.reloadIfNeed(tableView: self.tableView)
        })
    }
    
    func getUserFollowsBy(urlPath: String) {
        self.userListProvider.page += 1
        userListProvider.getUserFollows(urlPath: urlPath, completion: {[weak self] (users, error) in
            guard let `self` = self else { return }
            guard error == nil else {
                return
            }
            guard let users = users else { return }
            self.userListDataSource.updateFollowsList(users)
            self.userListDataSource.reloadSection(section: .follows, for: self.tableView)
        })
    }
    
    func setUsername(_ username: String?) {
        if let username = username {
            self.username = username
        }
    }
}
