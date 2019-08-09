//
//  Movie.swift
//  movieApp
//
//  Created by Matheus Azevedo on 08/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let title: String
    let releaseDate: String
    let genreIds: [Int]
    let overview: String
    
}
