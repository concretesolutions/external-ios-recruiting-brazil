//
//  FilterViewModel.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

class FilterViewModel {
    var datasource: GenericDataSource<Genre>?
    var status: DynamicValue<Event>?
    private let genreRepository = SwinjectContainer.container.resolve(GenreRepository.self)!

    init(dataSource: GenericDataSource<Genre>) {
        self.datasource = dataSource
        
        let event   = DynamicValue<Event>(.waiting)
        self.status = event
    }
    
    func getGenres() {
        genreRepository.getGenres(completion: { result in
            switch result {
            case .success(payload: let genres):
                self.status?.value = .success(nil)
                self.datasource?.data.value = genres
                
            case .failure(event: let event):
                self.status?.value = event
            }
        })
    }
}
