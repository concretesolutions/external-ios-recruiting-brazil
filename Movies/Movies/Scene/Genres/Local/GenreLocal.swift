//
//  GenreLocal.swift
//  Movies
//
//  Created by Alexandre Thadeu on 05/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import CoreData

class GenreLocal: BaseLocal {
    
    func insertGenre(genre: Genre) throws {
        let genreEntity = GenresEntity(context: self.context!)
        
        genreEntity.genreId = genre.genreId
        genreEntity.name = genre.name
        
        self.context!.insert(genreEntity)
        try context!.save()
    }
    
    func insertGenres(genres: [Genre]) throws {
        
        for genre in genres {
            let genreEntity = GenresEntity(context: self.context!)
            genreEntity.genreId = genre.genreId
            genreEntity.name = genre.name
            self.context!.insert(genreEntity)
        }

        try context!.save()
    }
    
    func fetchGenres() throws -> [Genre] {
        let genresEntity = try context!.fetch(GenresEntity.fetchRequest() as NSFetchRequest<GenresEntity>)
        var genres: [Genre] = []
        for genreEntity in genresEntity {
            genres.append(retrieveGenre(genreEntity: genreEntity))
        }
        return genres
    }
    
    func fetchGenres(genresId: [Int]) throws -> [Genre] {
        let request = NSFetchRequest<GenresEntity>(entityName: "GenresEntity")
        var genres: [Genre] = []
        
        request.predicate = NSPredicate(format: "genreId IN %@", genresId)
        let genresEntity = try self.context!.fetch(request)
        
        for genreEntity in genresEntity {
            genres.append(retrieveGenre(genreEntity: genreEntity))
        }
        
        return genres
    }
    
    func retrieveGenre(genreEntity: GenresEntity) -> Genre {
        return Genre(genreId: genreEntity.genreId, name: genreEntity.name)
    }
}
