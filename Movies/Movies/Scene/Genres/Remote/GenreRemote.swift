//
//  GenresRemote.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

class GenreRemote: BaseRemote {
    typealias getGenresResult = Result<[Genre], failureReason>
    typealias getGenresCompletion = (_ result: getGenresResult) -> Void
    private let serviceClient =  SwinjectContainer.container.resolve(ServiceClient.self)!
    
    func getGenres(completion: @escaping getGenresCompletion) {
        serviceClient.doRequest(router: .getGenres, completion: { result in
            switch result {
            case .success(payload: let data):
                
                do {
                    let genres = try [Genre].decode(data: data)
                    completion(.success(payload: genres))
                } catch {
                    completion(.failure(nil))
                }
                
            case .failure(let reason):
                completion(.failure(reason))
            }
        })
    }
}
