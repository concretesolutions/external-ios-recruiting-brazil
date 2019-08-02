//
//  BaseTabBarViewController.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupSearch() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.barTintColor = .white
        
    }
    
    func removeSearch() {
         self.navigationItem.searchController = nil
    }
    
    func setupNavTitle(title: String, setSearch: Bool ) {
        self.navigationItem.title = title
        if setSearch {
            setupSearch()
        }
    }
    
}
extension BaseTabBarViewController: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //self.baseViewModel.searchText?.value = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationItem.searchController?.searchBar.text = ""
        //self.baseViewModel.searchText?.value = ""
    }
}
