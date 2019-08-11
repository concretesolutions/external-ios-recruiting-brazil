//
//  DetailsViewController.swift
//  movieApp
//
//  Created by Matheus Azevedo on 09/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!

    @IBOutlet weak var movieName: UILabel!
    
    @IBOutlet weak var movieYear: UILabel!
    
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var movie: Movie?
    
    var genre = [String]()
    var image = UIImage()
    
    var isFavorited: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImage.image = image
        movieName.text = movie?.title
        movieYear.text = movie?.year
        movieGenres.text = genre.joined(separator:", ")
        overviewText.text = movie?.overview
        
        overviewText.isEditable = false
        
        //Check if is already favorited
        let favorite = DatabaseManager.shared.realm.object(ofType: FavoritedMovie.self, forPrimaryKey: movie?.id)
        if favorite != nil {
            isFavorited = true
            favoriteButton.setBackgroundImage(UIImage(imageLiteralResourceName: "favorite_full_icon"), for: .normal)
        }  else {
            isFavorited = false
            favoriteButton.setBackgroundImage(UIImage(imageLiteralResourceName: "favorite_gray_icon"), for: .normal)
        }
    
   
    }
 

    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        DatabaseManager.shared.saveFavorite(movie!)
        
        let favoriteIcon = UIImage(imageLiteralResourceName: "favorite_full_icon")
     
        favoriteButton.setBackgroundImage(favoriteIcon, for: .normal)
    }
    
    
}
