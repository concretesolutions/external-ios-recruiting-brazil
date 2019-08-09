//
//  FavouriteListDataSource.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

class FavouriteListDataSource: GenericDataSource<Movie>, UICollectionViewDataSource {
    lazy var viewModel: FavouriteListViewModel = {
        return FavouriteListViewModel(dataSource: self)
    }()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionCell.movieCell.rawValue, for: indexPath) as? MovieCollectionViewCell  else {
            return UICollectionViewCell()
        }
        
        let movie = data.value[indexPath.row]
        cell.configCell(movie: movie)
        cell.addBorderOnCell()
        cell.addShadowOnCell()
        cell.favouriteDelegate = self
        cell.favouriteCell = true
        return cell
    }
}
extension FavouriteListDataSource: FavouriteCellDelegate {
    func refreshTable() {
        viewModel.getMovies()
    }
    
}
