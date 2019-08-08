//
//  LocalMovie.swift
//  Movies
//
//  Created by Alexandre Thadeu on 05/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import CoreData

class MovieLocal: BaseLocal {
    func insertMovie(movie: Movie) throws {
        let movieEntity = MovieEntity(context: self.context!)
        
        movieEntity.movieId = movie.movieId
        movieEntity.genresId = movie.genresId
        movieEntity.originalTitle = movie.originalTitle
        movieEntity.originalLanguage = movie.originalLanguage
        movieEntity.popularity = movie.popularity != nil ? movie.popularity! : 0
        movieEntity.voteCount = movie.voteCount != nil ? Int32(movie.voteCount!) : 0
        movieEntity.voteAverage = movie.voteAverage != nil ? movie.voteAverage! : 0
        movieEntity.adult = movie.adult != nil ? movie.adult! : false
        movieEntity.overview = movie.overview
        movieEntity.backdropPath = movie.backdropPath
        movieEntity.posterPath = movie.posterPath
        movieEntity.releaseDate = movie.releaseDate
        
        self.context!.insert(movieEntity)
        try context!.save()
    }
    
    func insertMovies(movies: [Movie]) throws {
        for movie in movies {
            let movieEntity = MovieEntity(context: self.context!)
            
            movieEntity.movieId = movie.movieId
            movieEntity.genresId = movie.genresId
            movieEntity.originalTitle = movie.originalTitle
            movieEntity.originalLanguage = movie.originalLanguage
            movieEntity.popularity = movie.popularity != nil ? movie.popularity! : 0
            movieEntity.voteCount = movie.voteCount != nil ? Int32(movie.voteCount!) : 0
            movieEntity.voteAverage = movie.voteAverage != nil ? movie.voteAverage! : 0
            movieEntity.adult = movie.adult != nil ? movie.adult! : false
            movieEntity.overview = movie.overview
            movieEntity.backdropPath = movie.backdropPath
            movieEntity.posterPath = movie.posterPath
            movieEntity.releaseDate = movie.releaseDate
            
            self.context!.insert(movieEntity)
        }
        try context!.save()
    }
    
    func fetchMovies() throws -> [Movie]  {
        let moviesEntity = try context!.fetch(MovieEntity.fetchRequest() as NSFetchRequest<MovieEntity>)
        var movies: [Movie] = []
        for movieEntity in moviesEntity {
            movies.append(retrieveMovie(movieEntity: movieEntity))
        }
        return movies
    }
    
    func deleteMovie(movieId: Int64) throws {
        let request = NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
        let movies = try self.context!.fetch(request)
        
        for movie in movies {
            if movie.movieId == movieId {
                self.context!.delete(movie)
            }
        }
        try self.context!.save()
    }
    
    func retrieveMovie(movieEntity: MovieEntity) -> Movie {
       return Movie(movieId: movieEntity.movieId,
                    voteCount: Int(movieEntity.voteCount),
                    video: movieEntity.video,
                    voteAverage: movieEntity.voteAverage,
                    title: movieEntity.title,
                    popularity: movieEntity.popularity,
                    posterPath: movieEntity.posterPath,
                    originalLanguage: movieEntity.originalLanguage,
                    originalTitle: movieEntity.originalTitle,
                    genresId: movieEntity.genresId,
                    overview: movieEntity.overview,
                    adult: movieEntity.adult,
                    backdropPath: movieEntity.backdropPath,
                    releaseDate: movieEntity.releaseDate
        )
    }
}
