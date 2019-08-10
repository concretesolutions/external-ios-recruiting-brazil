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
    
    
    var name = ""
    var releaseDate = ""
    var genre = [String]()
    var overview = ""
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieImage.image = image
        movieName.text = name
        movieYear.text = String(releaseDate.prefix(4))
        movieGenres.text = genre.joined(separator:", ")
        overviewText.text = overview
        
        overviewText.isEditable = false
        
        // Do any additional setup after loading the view.
    }
 

}
