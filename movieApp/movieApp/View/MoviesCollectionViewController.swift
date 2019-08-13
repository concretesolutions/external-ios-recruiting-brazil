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
private var genreList: GenreList?

enum ViewState {
    case defaultScreen
    case loading
    case emptySearch
    case genericError
}


class MoviesCollectionViewController: UICollectionViewController {
    
    var requester: MovieDBRequestProtocol?
    
    //MARK: View State
    @IBOutlet weak var warningLabel: UILabel!
    
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)

    private var viewState: ViewState = .loading {
        didSet {
            loadingIndicator.stopAnimating()
            switch viewState {
            case .defaultScreen:
                loadingIndicator.isHidden = true
                warningLabel.isHidden = true
            case .loading:
                loadingIndicator.isHidden = false
                loadingIndicator.startAnimating()
                warningLabel.isHidden = true
            case .genericError:
                loadingIndicator.isHidden = true
                warningLabel.isHidden = false
                warningLabel.text = "Um erro ocorreu. Por favor, tente novamente"
            case .emptySearch:
                loadingIndicator.isHidden = true
                warningLabel.isHidden = false
                warningLabel.text = "Sua busca não retornou resultados"
            }
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Dismiss keyboard
        self.collectionView.keyboardDismissMode = .onDrag
        
        //Configure view
        self.view.addSubview(loadingIndicator)
        loadingIndicator.frame = self.view.bounds
        loadingIndicator.startAnimating()
        warningLabel.isHidden = true
        
        if requester == nil {
            requester = MovieRequester()
        }
        //Load genre list
        requester!.getGenreList { (success, result) in
            if success, let list = result {
                genreList = list
            }
        }
        
        loadMovies()
      
    }
    
    //MARK: Requests
    
    ///Calls request funcion to load most popular movies
    func loadMovies() {
        movieList = nil
        requester!.getPopularMovies { (success, result) in
            if success, let list = result {
                movieList = list
                self.viewState = .defaultScreen
            } else {
                self.viewState = .genericError
            }
        }
    }
    
    ///Calls request funcion to load searched movies
    func searchMovies(_ query: String) {
        movieList = nil
        self.requester!.getSearchedMovies(named: query) { (success, result) in
            if success {
                if let list = result, list.results.count > 0 {
                    movieList = list
                    self.viewState = .defaultScreen
                } else {
                    self.viewState = .emptySearch
                }
            } else {
                self.viewState = .genericError
            }
        }
    }
    
    
    //MARK: Data treatment
    
    ///Create a array of string with corresponding names to each genreId in a single Movie
    func idToGenreName(for movie: Movie) -> [String]{
        var genres = [String]()
        guard let allGenres = genreList?.genres else { return genres }
        
        for id in movie.genreIds {
            for genre in allGenres{
                if id == genre.id {
                    genres.append(genre.name)
                    break
                }
            }
        }
        
        return genres
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList?.results.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCollectionViewCell
        // Configure the cell
        if let movie = movieList?.results[indexPath.row] {
            cell.movieTitle.text = movie.title
            let data = try? Data(contentsOf: movie.imageUrl)
            if let imageData = data {
                cell.movieImage.image = UIImage(data: imageData)
            } else {
                cell.movieImage.image = UIImage(imageLiteralResourceName: "no_image_available_icon.jpg")
            }
        }
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        guard let selectedMovie = movieList?.results[indexPath.row] else { return }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? MoviesCollectionViewCell {
            vc?.image = selectedCell.movieImage.image ?? UIImage()
        }
        vc?.movie = selectedMovie
        vc?.genre = self.idToGenreName(for: selectedMovie)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

///Spacing and cell size
extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem*1.5)
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

// MARK: TexFieldDelegate
extension MoviesCollectionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        guard let query = textField.text else { return false }
        
        //Request search
        self.viewState = .loading
        self.searchMovies(query)
    
        return true
    }
    
    
}

//MARK: Info functions
extension MoviesCollectionViewController {
    ///Returns the view state at the moment
    func actualViewState() -> ViewState{
        return self.viewState
    }
}
