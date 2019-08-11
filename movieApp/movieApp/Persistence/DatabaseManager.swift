//
//  DatabaseManager.swift
//  movieApp
//
//  Created by Matheus Azevedo on 11/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Realm
import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()
    
    let realm: Realm
    
    init() {
        realm = try! Realm()
    }
    
    func saveFavorite(_ movie: Movie) {
        if self.realm.object(ofType: FavoritedMovie.self, forPrimaryKey: movie.id) != nil {
            //Movie as been already favorited
            return
        }
        
        let newMovie = FavoritedMovie()
        newMovie.id = movie.id
        newMovie.title = movie.title
        newMovie.year = movie.releaseDate
        newMovie.overview = movie.overview
        newMovie.imageURL = movie.imagePath.absoluteString
        
        try! realm.write {
            realm.add(newMovie)
        }
    }
}
