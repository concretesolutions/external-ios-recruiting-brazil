//
//  ServiceClient.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import Alamofire

class ServiceClient: BaseRemote {
    typealias requestResult = Result<Data, failureReason>
    typealias requestCompletion = (_ result: requestResult) -> Void
    
    func doRequest(router: Router, completion: @escaping requestCompletion) {
        if NetworkState.isConnected() {
            Alamofire.request(router)
                .validate()
                .responseJSON { response  in
                    self.logRequestAndResponse(request: response.request, response: response.response)
                    switch response.result  {
                    case .success:
                        switch router {
                        case .getGenres:
                            if let JSON = response.result.value {
                                if let json = JSON as? [String: Any], let results = json["genres"] {
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject:results)
                                        completion(.success(payload: data))
                                    } catch {
                                        completion(.failure(nil))
                                    }
                                }
                            }
                        case .getMovieList:
                            if let JSON = response.result.value {
                                if let json = JSON as? [String: Any], let results = json["results"] {
                                    do {
                                        let data = try JSONSerialization.data(withJSONObject:results)
                                        completion(.success(payload: data))
                                    } catch {
                                        completion(.failure(nil))
                                    }
                                }
                            }
                        }
                       
                       
                        
                    case .failure(_):
                        if let statusCode = response.response?.statusCode, let reason = failureReason(rawValue: statusCode) {
                            completion(.failure(reason))
                        } else {
                            completion(.failure(nil))
                        }
                    }
            }
        } else {
            completion(.failure(.noNetwork))
        }
        
    }
    
    private func logRequestAndResponse(request: URLRequest?, response: HTTPURLResponse? ) {
        if let request = request {
            NSLog("Request to: \(request.url?.absoluteString ?? "--")")
            NSLog("Method: \(request.httpMethod ?? "--")")
        }
        
        if let response = response {
            NSLog("Response Status Code: \(response.statusCode)")
        }
        
        NSLog("----------------------------------------------------------------")
    }
    
}
