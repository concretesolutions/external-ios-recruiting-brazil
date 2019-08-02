//
//  Genres.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

 struct Genre: Codable {
    let genreId: Int64
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case genreId = "id"
        case name
    }
}
