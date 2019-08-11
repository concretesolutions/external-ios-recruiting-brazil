//
//  FavoritedMovie.swift
//  movieApp
//
//  Created by Matheus Azevedo on 11/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Realm
import RealmSwift

class FavoritedMovie: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var year: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var imagePath: String = ""
    
    override static func primaryKey() -> String {
        return "id"
    }
    
 
}
