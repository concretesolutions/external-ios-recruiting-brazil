//
//  ImageRouter.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

enum ImageRouter {
    case getImage(imageString: String)
    
    var baseUrl: String {
         return "https://image.tmdb.org/"
    }
    
    var path: String {
        switch self {
        case .getImage(let imageString):
            return "t/p/w500/\(imageString)"
        }
    }
    
    var url: URL {
        let urlString = baseUrl + path
        let url = URL(string: urlString)!
        return url
    }
}
