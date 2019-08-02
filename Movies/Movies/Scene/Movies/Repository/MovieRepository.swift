//
//  MovieRepository.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import Swinject

struct MovieRepository {
    typealias getMovieResult = RepositoryResult<[Movie], Event>
    typealias getMovieCompletion = (_ result: getMovieResult) -> Void
    
    private let moviewRemote = Container().resolve(MovieRemote.self)!
    
    func getMoviesList(page: Int?, completion: @escaping getMovieCompletion) {
        moviewRemote.getMoviesList(page: page, completion: { result in
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
}