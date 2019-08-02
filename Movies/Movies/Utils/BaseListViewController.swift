//
//  BaseListViewController.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class BaseListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupNavBar() {
        self.tabBarController?.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        
        
         self.tabBarController?.navigationItem.searchController = searchController
         self.tabBarController?.navigationController?.navigationBar.barTintColor = .white
        
    }
    
    func setTitle(title: String) {
        self.tabBarController?.navigationItem.title = title
    }


}
extension BaseListViewController: UISearchBarDelegate, UISearchResultsUpdating {
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
