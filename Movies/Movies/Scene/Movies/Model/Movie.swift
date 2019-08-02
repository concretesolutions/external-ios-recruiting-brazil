//
//  Movie.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var movieId: Int
    var voteCount: Int?
    var video: Bool?
    var voteAverage: Float?
    var title: String?
    var popularity: Float?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genresId: [Int]?
    var overview: String?
    var adult: Bool?
    var backdropPath: String?
    var releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case movieId            = "id"
        case voteCount          = "vote_count"
        case voteAverage        = "vote_average"
        case title
        case popularity
        case originalLanguage   = "original_language"
        case originalTitle      = "original_title"
        case posterPath         = "poster_path"
        case genresId           = "genres_id"
        case overview
        case adult
        case backdropPath       = "backdrop_path"
        case releaseDate        = "release_date"
    }

}
