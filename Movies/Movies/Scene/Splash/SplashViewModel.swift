//
//  SplashViewModel.swift
//  Movies
//
//  Created by Alexandre Thadeu on 07/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation

class SplashViewModel {
    var status: DynamicValue<Event>?
    let genreRepository = SwinjectContainer.container.resolve(GenreRepository.self)!
    
    init() {
        let event   = DynamicValue<Event>(.waiting)
        self.status = event
    }
    
    func getGenres() {
        genreRepository.getGenres(completion: { result in
            switch result {
            case .success:
                self.status?.value = .success(nil)
            case .failure(event: let event):
                self.status?.value = event
            }
        })
    }
}
