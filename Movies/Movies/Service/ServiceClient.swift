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
                        guard let data = response.data else {
                            
                            if let statusCode = response.response?.statusCode, statusCode >= 200 &&  statusCode < 300 {
                                let data = Data(count: 1)
                                completion(.success(payload: data))
                            }
                            
                            completion(.failure(nil))
                            return
                        }
                        completion(.success(payload: data))
                        
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
