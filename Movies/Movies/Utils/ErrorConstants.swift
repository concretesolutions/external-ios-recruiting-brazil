//
//  ErrorConstants.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

enum ErrorConstant: String {
    case noNetwork = "Sem conexão com a Internet, fique online e tente de novo."
    case unAuthorized = "Sem autorização."
    case empty = "Não há filmes para essa busca."
    case errorMessage = "Estamos com algum problema, tente novamente mais tarde."
}
