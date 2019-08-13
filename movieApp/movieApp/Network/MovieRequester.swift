//
//  MovieRequester.swift
//  movieApp
//
//  Created by Matheus Azevedo on 12/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Foundation
import Moya

class MovieRequester {
    let provider: MoyaProvider<MovieDB>
    
    init() {
        provider = MoyaProvider<MovieDB>()
    }
    
    ///Get most popular movies
    func getPopularMovies(completion: @escaping (_ success: Bool, MovieList?) -> ()){
        provider.request(.showPopularMovies) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //Convert JSON snake cases to variable camel case
                    let movieList = try decoder.decode(MovieList.self, from: response.data)
                    completion(true, movieList)
                } catch {
                    print("Erro ao receber dados")
                    completion(false, nil)
                }
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    ///Get movies which title contains searched characteres
    func getSearchedMovies(named query: String, completion: @escaping (_ success: Bool, MovieList?) -> ()) {
        provider.request(.searchMovies(query: query)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //Convert JSON snake cases to variable camel case
                    
                    let movieList = try decoder.decode(MovieList.self, from: response.data)
                    completion(true, movieList)
                } catch {
                    print("Erro ao receber dados")
                    completion(true, nil)//Sends "true" so it can handles has empty search
                }
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
    ///Get list of movie genres
    func getGenreList(completion: @escaping (_ success: Bool, GenreList?) -> ()){
        provider.request(.genreList) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let genreList = try decoder.decode(GenreList.self, from: response.data)
                    completion(true, genreList)
                } catch {
                    completion(false, nil)
                }
            case .failure(let error):
                print(error)
                completion(false, nil)
            }
        }
    }
    
}
