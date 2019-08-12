//
//  MovieDB.swift
//  movieApp
//
//  Created by Matheus Azevedo on 09/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Foundation
import Moya

enum MovieDB {
    static private let apiKey = "3364f96fa6acefbd524335c6cc0a4932"
    
    case showPopularMovies
    case genreList
    case searchMovies(query: String)
}

extension MovieDB: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch  self {
        case .showPopularMovies:
            return "/discover/movie"
        case .genreList:
            return "/genre/movie/list"
        case .searchMovies(_):
            return "/search/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .showPopularMovies, .genreList, .searchMovies:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data() 
    }
    
    var task: Task {
        switch self {
        case .showPopularMovies, .genreList:
            return .requestParameters(parameters: ["api_key": MovieDB.apiKey], encoding: URLEncoding.queryString)
        case let .searchMovies(query):
            return .requestParameters(parameters: ["api_key": MovieDB.apiKey, "query": query], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
