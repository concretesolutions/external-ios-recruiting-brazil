//
//  FavouriteListViewController.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class FavouriteListViewController: UIViewController {
    private let dataSource = FavouriteListDataSource()
    lazy var viewModel: FavouriteListViewModel = {
        return FavouriteListViewModel(dataSource: dataSource)
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            let cell = UINib(nibName: "MovieCollectionViewCell", bundle: nil)
            collectionView.register(cell, forCellWithReuseIdentifier: Identifiers.CollectionCell.movieCell.rawValue)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.getMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configBinds()
    }
    
    func configUI() {
        self.collectionView.dataSource = dataSource
        self.collectionView.delegate = self
    }
    
    func configBinds() {
        self.viewModel.dataSource?.data.addAndNotify(observer: self) { [weak self] in
            self?.collectionView.reloadData()
            
            if let movies = self?.viewModel.dataSource?.data.value, movies.count > 0 {
                self?.collectionView.restore()
                self?.collectionView.reloadData()
            } else {
                self?.collectionView.setEmptyMessage("Você não tem filmes favoritados :(")
            }
        }
        
        self.viewModel.status?.addAndNotify(observer: self) {[weak self] in
            guard let status = self?.viewModel.status?.value else { return }
            switch(status) {
            case .error(let message):
                Alert.errorAlert(message: message, controller: self)
            case .success, .empty, .waiting:
                break
            case .loading:
                print("Loading")
            }
        }
    }
}

extension FavouriteListViewController: FilterMovieDelegate {
    func filterMovie(genreId: [Int64]) {
        self.viewModel.getMovies()
    }
    
    
}
