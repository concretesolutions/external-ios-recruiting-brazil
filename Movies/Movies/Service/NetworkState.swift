//
//  NetworkState.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

import Foundation
import Alamofire

class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
