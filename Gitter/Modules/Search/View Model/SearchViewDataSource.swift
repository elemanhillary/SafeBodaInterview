//
//  SearchViewDataSource.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import Foundation
import UIKit
import SDWebImage

class SearchViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    var onFetchMore: ((_ userId: Int?) -> Void)?
    var onUserTapped: ((_ username: String?) -> Void)?
    
    private var dataList = [User]()
    
    func updateList(_ dataList: [User]) {
        self.dataList = dataList
    }
    
    func getDataList() -> [User] {
        return dataList
    }
    
    func reloadIfNeed(tableView: UITableView) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.configure(UserCell.self, with: dataList[indexPath.item], for: indexPath)
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let user = dataList[indexPath.row]
        onUserTapped?(user.login)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataList.count - 1  {
            onFetchMore?(dataList[indexPath.row].id)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        /// estimated height greater than cell height
        return 1000
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let urls: [URL]? = indexPaths.map { indexPath in
            let imagePath = dataList[indexPath.row].avatar_url
            let url = URL.init(string: imagePath ?? "")
            return url!
        }
        SDWebImagePrefetcher.shared.prefetchURLs(urls)
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        SDWebImagePrefetcher.shared.cancelPrefetching()
    }
}
