//
//  FilterDataSource.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

class FilterDataSource: GenericDataSource<Genre>, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CollectionCell.genreFilterCell.rawValue, for: indexPath) as? FilterGenreCollectionViewCell  else {
            return UICollectionViewCell()
        }
        cell.genre = data.value[indexPath.row]
        return cell
    }
    
}
