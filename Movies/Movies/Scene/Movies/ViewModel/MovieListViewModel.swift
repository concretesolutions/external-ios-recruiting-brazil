//
//  MovieListViewModel.swift
//  Movies
//
//  Created by Alexandre Thadeu on 06/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation


class MovieListViewModel {
    var dataSource: GenericDataSource<Movie>?
    var status: DynamicValue<Event>?
    var movieRepository = SwinjectContainer.container.resolve(MovieRepository.self)!
    
    init(dataSource: GenericDataSource<Movie>) {
        self.dataSource = dataSource
        let event   = DynamicValue<Event>(.waiting)
        self.status = event
    }
    
    func getMovies(page: Int?) {
        movieRepository.getMoviesList(page: page ?? 1, completion: { result in
            switch result {
            case .success(payload: let movies):
                self.dataSource?.data.value = movies
                self.status?.value = .success(nil)
                
            case .failure(event: let event):
                self.status?.value = event
            }
        })
    }
}
