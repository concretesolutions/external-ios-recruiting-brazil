//
//  BaseTabBarViewController.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class MovieTabBarViewController: BaseTabBarViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.removeSearch()
        self.setupNavTitle(title: "Filmes", setSearch: false)
        self.removeRightBarButton()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case 0:
            self.removeSearch()
            self.setupNavTitle(title: "Filmes", setSearch: false)
            self.removeRightBarButton()
        case 1:
            self.setupNavTitle(title: "Filmes Favoritos ♡", setSearch: true)
            self.addRightBarButton()
        default:
            self.removeSearch()
            self.setupNavTitle(title: "Movie", setSearch: false)
            self.removeRightBarButton()

        }
    
    }
}
