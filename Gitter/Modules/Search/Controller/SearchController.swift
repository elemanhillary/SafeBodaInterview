//
//  SearchController.swift
//  Gitter
//
//  Created by MacBook Pro on 5/14/22.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var onUserTapped: ((String?) -> Void)?
    
    private var userListProvider = SearchViewDataProvider()
    private var userListDataSource = SearchViewDataSource()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.definesPresentationContext = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.placeholder = "Search"
        searchController.delegate = self
        return searchController
    }()
    
    private var refreshControl: UIRefreshControl!
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? false
    }
    
    var isSearching: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(SearchController.refreshList(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.separatorColor = .clear
        tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.dataSource = userListDataSource
        tableView.delegate = userListDataSource
        tableView.register(UserCell.self)
        
        /// fetch more users when user reaches last cell, github uses user ids for pagination
        userListDataSource.onFetchMore = {[weak self] userId in
            guard let `self` = self else { return }
            if !self.isSearching {
                self.fetchMoreUsers(since: userId)
            }
        }
        
        userListDataSource.onUserTapped = {[weak self] username in
            self?.onUserTapped?(username)
        }
        
        /// fetch user list on load view
        fetchDiscoverList(isRefreshing: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Gitter"
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationItem.standardAppearance = navigationBarAppearance
    }
    
    @IBAction func refreshList(_ sender: UIRefreshControl) {
        tableView.refreshControl?.beginRefreshing()
        fetchDiscoverList(isRefreshing: true)
    }
    
    func fetchMoreUsers(since: Int?) {
        if let since = since {
            fetchDiscoverList(since: since, isRefreshing: false)
        }
    }
    
    func fetchDiscoverList(since: Int = 1, isRefreshing: Bool) {
        userListProvider.since = since
        userListProvider.getUsers(completion: {[weak self] (response, error) in
            /// end refresh from this point because` incase self is nil refresh control wont stop`
            if isRefreshing {
                self?.tableView.refreshControl?.endRefreshing()
            }
            guard let `self` = self else { return }
            guard error == nil else {
                return
            }
            guard let response = response else { return }
            self.userListDataSource.updateList(response)
            self.userListDataSource.reloadIfNeed(tableView: self.tableView)
        })
    }
    
    func fetchSearchUser(query: String) {
        userListProvider.page += 1
        userListProvider.searchUsers(query: query, completion: {[weak self] (response, error) in
            guard let `self` = self else { return }
            guard error == nil else {
                return
            }
            guard let response = response else { return }
            self.userListDataSource.updateList(response)
            self.userListDataSource.reloadIfNeed(tableView: self.tableView)
        })
    }
    
    func searchContent(_ searchText: String) {
        if isSearching {
            let results = userListProvider.cacheFirstSearch(query: searchText)
            if results.isEmpty {
                userListProvider.page = 0
                fetchSearchUser(query: searchText.lowercased())
            } else {
                userListDataSource.updateList(results)
                userListDataSource.reloadIfNeed(tableView: self.tableView)
            }

        } else {
            userListDataSource.updateList(userListProvider.users)
            userListDataSource.reloadIfNeed(tableView: self.tableView)
        }
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        searchContent(searchBar.text!)
    }
}

extension SearchController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
    }

    func willDismissSearchController(_ searchController: UISearchController) {
        userListDataSource.updateList(userListProvider.users)
        userListDataSource.reloadIfNeed(tableView: self.tableView)
    }
}
