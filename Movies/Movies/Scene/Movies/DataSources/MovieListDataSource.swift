//
//  MovieListDataSource.swift
//  Movies
//
//  Created by Alexandre Thadeu on 06/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

class MovieDataSource: GenericDataSource<Movie>, UICollectionViewDataSource {
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
        return cell
    }
    
    
}
