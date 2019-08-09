//
//  MovieListCollectionDelegate.swift
//  Movies
//
//  Created by Alexandre Thadeu on 07/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

extension MoviesListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let baseHeight: CGFloat = 70
        let width = self.collectionView.frame.width - 30
        let height = (width * 0.75) + baseHeight
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (indexPath.row == dataSource.data.value.count - 1 ) {
            self.page += 1
            self.viewModel.getMovies(page: page)
        }
    }
}
