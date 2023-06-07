//
//  SearchViewController.swift
//  STYLiSH
//
//  Created by Milton Liu on 2023/6/7.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("搜尋")
        navigationItem.largeTitleDisplayMode = .never
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("找找你有興趣的服飾")
        navigationItem.searchController = searchController
        definesPresentationContext = true

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }



}

// MARK: - Search result update
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }
}
