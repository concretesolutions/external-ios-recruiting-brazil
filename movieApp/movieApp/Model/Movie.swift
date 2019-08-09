//
//  Movie.swift
//  movieApp
//
//  Created by Matheus Azevedo on 08/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Foundation

class Movie {
    let name: String
    let year: Int
    let genreIDs: [Int]
    let overview: String
    
    init(name: String, year: Int, genreIDs: [Int], overview: String) {
        self.name = name
        self.year = year
        self.genreIDs = genreIDs
        self.overview = overview
    }
}
