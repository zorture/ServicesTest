//
//  SearchViewController.swift
//  ServicesTest
//
//  Created by Kanwar Zorawar Singh Rana on 8/1/18.
//  Copyright © 2018 Xorture. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {

    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for movies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        viewModel = ViewModel.init(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.dataModel?.results?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let results = viewModel.dataModel?.results {
            let result  = results[indexPath.row]
            cell.textLabel?.text = result.title
        }
        return cell
    }

}

extension SearchViewController: ViewModelDelegates {
    func didReceiveData() {
        tableView.reloadData()
    }
}

extension SearchViewController : UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else { return }
        viewModel.fetchPost(searchQuery: text)
    }
    

}
