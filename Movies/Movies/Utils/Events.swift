//
//  Events.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

enum Event: Error {
    case error(message: String)
    case empty(message: String)
    case loading
    case success(Any?)
    case waiting
}
