//
//  SplashViewController.swift
//  Movies
//
//  Created by Alexandre Thadeu on 07/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    
    lazy var viewModel: SplashViewModel = {
        return SplashViewModel()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configBinds()
        self.viewModel.getGenres()
    }
    
    func configBinds() {
        self.viewModel.status?.addAndNotify(observer: self) { [weak self] in
            guard let status = self?.viewModel.status?.value else { return }
            switch status {
            case .success, .empty:
                self?.performSegue(withIdentifier: "goToMovies", sender: nil)
                
            case .error(message: let message):
                NSLog(message)
                self?.performSegue(withIdentifier: "goToMovies", sender: nil)
            case .waiting:
                break
            case .loading:
                break
            }
        }
    }
    


}
