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
        print(realm.configuration.fileURL!)
    }
    
    func saveFavorite(_ movie: Movie) {
        if self.realm.object(ofType: FavoritedMovie.self, forPrimaryKey: movie.id) != nil {
            //Movie as been already favorited
            return
        }
        
        let newMovie = FavoritedMovie()
        newMovie.id = movie.id
        newMovie.title = movie.title
        newMovie.year = movie.year
        newMovie.overview = movie.overview
        newMovie.imagePath = movie.imageUrl.relativePath

        try! realm.write {
            realm.add(newMovie)
        }
    }
    
    func getSavedFavorites() -> [FavoritedMovie]{
        var array = [FavoritedMovie]()
        let elements = self.realm.objects(FavoritedMovie.self)
        for e in elements {
            array.append(e)
        }
        return array
    }
}
