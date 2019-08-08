//
//  Container.swift
//  Movies
//
//  Created by Alexandre Thadeu on 02/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

import Foundation
import Swinject

class SwinjectContainer {
    static let container = Container()
    static let shared = SwinjectContainer()
    
    func loadContainer() {
        SwinjectContainer.container.register(ServiceClient.self) { _ in ServiceClient() }
        
        SwinjectContainer.container.register(MovieRemote.self) { _ in MovieRemote() }
        SwinjectContainer.container.register(MovieLocal.self) { _ in MovieLocal() }
        SwinjectContainer.container.register(MovieRepository.self) { _ in MovieRepository() }
        
        SwinjectContainer.container.register(GenreRemote.self) { _ in GenreRemote() }
        SwinjectContainer.container.register(GenreRepository.self) { _ in GenreRepository() }
        SwinjectContainer.container.register(GenreLocal.self) { _ in GenreLocal() }
        
        SwinjectContainer.container.register(MovieDataSource.self) { _ in MovieDataSource() }
        SwinjectContainer.container.register(MovieListViewModel.self) { r in 
            return MovieListViewModel(dataSource: r.resolve(MovieDataSource.self)!)
        }
    }
}

