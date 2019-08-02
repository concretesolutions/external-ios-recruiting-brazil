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
    
    var baseUrl : String {
        return "https://api.themoviedb.org/3/"
    }
    
    var apiKey: String {
        return "07df8c9da251d396ca8e52a42b21dfcd"
    }
    
    var path : String {
        return "movie/top_rated/"
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovieList:
            return .get
        }
    }
    
    var parameters: [String:Any]? {
        var parameters: [String: Any] = [:]
        parameters["apiKey"] = self.apiKey
        switch self {
        case .getMovieList(let page):
            parameters["page"] = page ?? 0
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
