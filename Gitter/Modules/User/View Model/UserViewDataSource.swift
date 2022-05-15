//
//  UserViewDataSource.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import UIKit
import SDWebImage

class UserViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    var onFetchMore: (() -> Void)?
    var onUserTapped: ((_ username: String?) -> Void)?
    var onTappedFollowing: (() -> Void)?
    var onTappedFollowers: (() -> Void)?
    
    enum Sections: Int, CaseIterable {
        case header = 0, tab, follows
    }
    
    private var userDetails = User()
    private var userFollows = [User()]
    
    func updateList(_ data: User) {
        self.userDetails = data
    }
    
    func updateFollowsList(_ data: [User]) {
        self.userFollows = data
    }
    
    func getDataList() -> User {
        return userDetails
    }
    
    func reloadIfNeed(tableView: UITableView) {
        tableView.reloadData()
    }
    
    func reloadSection(section: Sections, for tableView: UITableView) {
        tableView.reloadSections([Sections.follows.rawValue], with: .fade)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// sections that have one piece of data defaults to 1 row
        switch section {
        case Sections.header.rawValue:
            return 1
        case Sections.tab.rawValue:
            return 1
        case Sections.follows.rawValue:
            return userFollows.count > .zero ? userFollows.count : 1
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Sections.header.rawValue:
            let cell = tableView.configure(HeaderCell.self, with: userDetails, for: indexPath)
            cell.selectionStyle = .none
            return cell
        case Sections.tab.rawValue:
            let cell = tableView.configure(TabCell.self, with: userDetails, for: indexPath)
            cell.onTappedFollowing = {[weak self] in
                self?.onTappedFollowing?()
                cell.followings.font = .boldSystemFont(ofSize: 14)
                cell.followers.textColor = .secondaryLabel
                cell.followings.textColor = .label
                cell.followers.font = .preferredFont(forTextStyle: .caption2).withSize(14)
            }
            cell.onTappedFollowers = {[weak self] in
                self?.onTappedFollowers?()
                cell.followers.font = .boldSystemFont(ofSize: 14)
                cell.followings.textColor = .secondaryLabel
                cell.followers.textColor = .label
                cell.followings.font = .preferredFont(forTextStyle: .caption2).withSize(14)
            }
            cell.selectionStyle = .none
            return cell
        case Sections.follows.rawValue:
            let cell = tableView.configure(UserCell.self, with: userFollows[indexPath.row], for: indexPath)
            return cell
        default:
            return UITableViewCell()
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.section == Sections.follows.rawValue else { return }
        let user = userFollows[indexPath.row]
        onUserTapped?(user.login)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == Sections.follows.rawValue else { return }
        /// fetch more if we are on the `last 4th cell`
        if indexPath.row == userFollows.count - 4  {
            onFetchMore?()
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        /// estimated height greater than cell height
        return 1000
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls: [URL?]? = indexPaths.map { indexPath in
            if indexPath.section == Sections.follows.rawValue{
                let imagePath = userFollows[indexPath.row].avatar_url
                let url = URL.init(string: imagePath ?? "")
                return url
            }
            return nil
        }
        
        var paths: [URL] = []
        if let urls = urls {
            paths = urls.compactMap { $0 }
        }
        SDWebImagePrefetcher.shared.prefetchURLs(paths)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        SDWebImagePrefetcher.shared.cancelPrefetching()
    }
}
