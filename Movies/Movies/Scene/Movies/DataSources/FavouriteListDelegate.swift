//
//  FavouriteListDelegate.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

extension FavouriteListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let baseHeight: CGFloat = 70
        let width = self.collectionView.frame.width - 30
        let height = (width * 0.75) + baseHeight
        
        return CGSize(width: width, height: height)
    }
}
