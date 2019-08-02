//
//  GenericResults.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error {
    case success(payload: T)
    case failure(U?)
}

enum RepositoryResult<T, U>{
    case success(payload: T)
    case failure(event: U)
}

