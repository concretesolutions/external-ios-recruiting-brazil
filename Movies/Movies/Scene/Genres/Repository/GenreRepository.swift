//
//  GenreRepository.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

class GenreRepository {
    typealias getGenresResult = RepositoryResult<[Genre], Event>
    typealias getGenresCompletion = (_ result: getGenresResult) -> Void
    
    private let genreRemote =  SwinjectContainer.container.resolve(GenreRemote.self)!
    private let genreLocal  =  SwinjectContainer.container.resolve(GenreLocal.self)!
    
    func getGenres(completion: @escaping getGenresCompletion) {
        
        do {
            let genres = try genreLocal.fetchGenres()
            if genres.count > 0 {
                completion(.success(payload: genres))
            }
        } catch let error {
            NSLog("Não foi possível trazer os genêros localmente: \(error.localizedDescription)")

        }
        
        genreRemote.getGenres(completion: { result in
            switch result {
            case .success(payload: let genres):
                do {
                    try self.genreLocal.insertGenres(genres: genres)
                } catch let error {
                    NSLog("Não foi possível salvar os genêros localmente: \(error.localizedDescription)")
                }
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
