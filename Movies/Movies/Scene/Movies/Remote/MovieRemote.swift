//
//  MovieRemote.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import Swinject

class MovieRemote: BaseRemote {
    typealias getMoviesResult = Result<[Movie], failureReason>
    typealias getMoviesCompletion = (_ result: getMoviesResult) -> Void
    private let serviceClient = Container().resolve(ServiceClient.self)!
    
    func getMovieList(page: Int? = 0, completion: @escaping getMoviesCompletion) {
        serviceClient.doRequest(router: .getMovieList(page: page), completion: { result in
            switch result {
            case .success(payload: let data):
                
                do {
                    let movies = try [Movie].decode(data: data)
                    completion(.success(payload: movies))
                } catch {
                    completion(.failure(nil))
                }
                
            case .failure(let reason):
                completion(.failure(reason))
            }
        })
    }
}
