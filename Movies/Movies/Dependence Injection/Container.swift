//
//  Container.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

extension AppDelegate {
    func registerData() {
        container.register(ServiceClient.self) { _ in ServiceClient() }
        
        container.register(MovieRemote.self) { _ in MovieRemote() }
        container.register(MovieRepository.self) { _ in MovieRepository() }
        
        container.register(GenreRemote.self) { _ in GenreRemote() }
        container.register(GenreRepository.self) {_ in GenreRepository() }
    }
}
