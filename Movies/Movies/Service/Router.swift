//
//  Router.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import Alamofire

 

enum Router: URLRequestConvertible {
    
    case getMovieList(page: Int?)
    case getGenres
  
    var baseUrl : String {
        switch self {
        case .getGenres, .getMovieList:
            return "https://api.themoviedb.org/3/"
        }
    }
    
    var apiKey: String {
        return "37d31119cfbe80b2c7ef01cf3735ea2b"
    }
    
    var language: String {
        return "Pt-BR"
    }
    
    var path : String {
        switch self {
        case .getMovieList:
            return "movie/top_rated/"

        case .getGenres:
            return "genre/movie/list"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovieList, .getGenres:
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        var parameters: [String: Any] = [:]
        parameters["api_key"] = self.apiKey
        parameters["language"] = self.language
        
        switch self {
        case .getMovieList(let page):
            parameters["page"] = page ?? 1
            return parameters
            
        case .getGenres:
            return parameters
            

        }
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = "\(baseUrl)\(path)"
        
        var urlRequest = URLRequest(url: try url.asURL())
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = TimeInterval(100)
        
        for header in headers {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        
        let request = try URLEncoding.default.encode(urlRequest, with: parameters)
        return request
    }
    
}
