//
//  ViewController.swift
//  movieApp
//
//  Created by Matheus Azevedo on 08/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import UIKit
import Moya

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Teste Moya
        let provider = MoyaProvider<MovieDB>()
        provider.request(.showPopularMovies) { result in
            switch result {
            case .success(let response):
                do {
                    let resultsArray = try response.mapJSON()
                    print(resultsArray)
                } catch {
                    print("erro")
                }
            case .failure(let error):
                print(error)
            }
        }
        
        print("TESTE DB")
    }


}

