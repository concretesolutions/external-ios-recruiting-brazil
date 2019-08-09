//
//  FilterGenreCollectionViewCell.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class FilterGenreCollectionViewCell: UICollectionViewCell {
    
    var genre: Genre? {
        didSet {
            nameLabel.text = genre?.name
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.borderWidth = 1
            cardView.layer.borderColor = UIColor.MovieBaseColors.yellow.cgColor
        }
    }
    
}
