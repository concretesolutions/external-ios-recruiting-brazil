//
//  FavouriteListViewModel.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

class FavouriteListViewModel {
    var dataSource: GenericDataSource<Movie>?
    var status: DynamicValue<Event>?
    var movieRepository = SwinjectContainer.container.resolve(MovieRepository.self)!
    
    init(dataSource: GenericDataSource<Movie>) {
        self.dataSource = dataSource
        let event   = DynamicValue<Event>(.waiting)
        self.status = event
    }
    
    func getMovies() {
        movieRepository.getFavouriteMovies(completion: { result in
            switch result {
            case .success(payload: let movies):
                self.dataSource?.backupData.value = movies
                self.dataSource?.data.value = movies
                self.status?.value = .success(nil)
                
            case .failure(event: let event):
                switch event {
                case .empty:
                    self.dataSource?.data.value = []
                default:
                    self.status?.value = event
                }
            }
        })
    }
}
