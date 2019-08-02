//
//  GenreRepository.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import Swinject

class GenreRepository {
    typealias getGenresResult = RepositoryResult<[Genre], Event>
    typealias getGenresCompletion = (_ result: getGenresResult) -> Void
    private let genreRemote = Container().resolve(GenreRemote.self)!
    
    func getGenres(completion: @escaping getGenresCompletion) {
        genreRemote.getGenres(completion: { result in
            switch result {
            case .success(payload: let genres):
                completion(.success(payload: genres))
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
