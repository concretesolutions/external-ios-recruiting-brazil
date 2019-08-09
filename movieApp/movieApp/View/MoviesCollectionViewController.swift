//
//  MoviesCollectionViewController.swift
//  movieApp
//
//  Created by Matheus Azevedo on 09/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import UIKit
import Moya

private let reuseIdentifier = "MovieCell"
private let itemsPerRow: CGFloat = 2
private let sectionInsets = UIEdgeInsets(top: 50.0,
                                         left: 20.0,
                                         bottom: 50.0,
                                         right: 20.0)
private var movieList: MovieList?

enum ExceptionType {
    case emptySearch
    case genericError
}

class MoviesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        loadMoviesData()
    }
    
    ///Request information from MovieDB
    func loadMoviesData() {
        let provider = MoyaProvider<MovieDB>()
        provider.request(.showPopularMovies) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //Convert JSON snake cases to variable camel case
                    
                    movieList = try decoder.decode(MovieList.self, from: response.data)
                    self.collectionView.reloadData()
                } catch {
                    print("Erro ao receber dados")
                    self.showExceptionScreen(.genericError)
                }
            case .failure(let error):
                print(error)
                self.showExceptionScreen(.genericError)
            }
        }
    }
    
    func showExceptionScreen(_ type: ExceptionType) {
        switch type {
        case .genericError:
            self.collectionView.backgroundColor = .red
        case .emptySearch:
            self.collectionView.backgroundColor = .gray
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movieList?.results.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
        // Configure the cell
        cell.backgroundColor = .black
        cell.movieTitle.text = movieList?.results[indexPath.row].title
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        vc?.name = movieList?.results[indexPath.row].title ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

///Define questoes de espaçamento e tamanho das celulas
extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
