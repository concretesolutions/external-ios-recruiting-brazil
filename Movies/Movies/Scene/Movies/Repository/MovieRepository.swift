//
//  MovieRepository.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

struct MovieRepository {
    typealias getMovieResult = RepositoryResult<[Movie], Event>
    typealias getMovieCompletion = (_ result: getMovieResult) -> Void
    
    private let movieRemote =  SwinjectContainer.container.resolve(MovieRemote.self)!
    private let movieLocal  =  SwinjectContainer.container.resolve(MovieLocal.self)!
    
    func getMoviesList(page: Int?, completion: @escaping getMovieCompletion) {
        movieRemote.getMoviesList(page: page, completion: { result in
            switch result {
            case .success(payload: let movies):
                completion(.success(payload: movies))
            case .failure(.unAuthorized?):
                completion(.failure(event: .error(message: ErrorConstant.unAuthorized.rawValue)))
            case .failure(.notFound?):
                completion(.failure(event: .empty(message: ErrorConstant.empty.rawValue)))
            case .failure(.none), .failure(.badRequest?):
                completion(.failure(event: .error(message: ErrorConstant.errorMessage.rawValue)))
            case .failure(.noNetwork?):
                completion(.failure(event: .error(message: ErrorConstant.noNetwork.rawValue)))
            }
        })
    }
    
    func getFavouriteMovies(completion: @escaping getMovieCompletion) {
        do {
            let movies = try movieLocal.fetchMovies()
            if movies.count > 0 {
                completion(.success(payload: movies))
            } else {
                completion(.failure(event: .empty(message: "Não há filmes favoritados.")))
            }
        } catch let error {
            completion(.failure(event: .error(message: error.localizedDescription)))
        }
    }
}
