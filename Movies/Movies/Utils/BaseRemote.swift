//
//  BaseRemote.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

class BaseRemote {
    enum failureReason: Int, Error {
        case unAuthorized   = 401
        case notFound       = 404
        case badRequest     = 400
        case noNetwork      = 0
    }
}
