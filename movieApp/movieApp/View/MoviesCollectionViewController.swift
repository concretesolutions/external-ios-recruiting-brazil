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

enum State {
    case defaultScreen
    case loading
    case emptySearch
    case genericError
}


class MoviesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    
    //MARK: View State
    
    private let loadingIndicator = UIActivityIndicatorView(style: .gray)

    private var viewState: State = .loading {
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
        
        loadGenreList()
        loadMoviesData()
    }
    
    //MARK: Requests
    func loadMoviesData() {
        if movieList != nil {
            movieList = nil
        }
        let provider = MoyaProvider<MovieDB>()
        provider.request(.showPopularMovies) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //Convert JSON snake cases to variable camel case
                    
                    movieList = try decoder.decode(MovieList.self, from: response.data)
                    self.viewState = .defaultScreen
                } catch {
                    print("Erro ao receber dados")
                    self.viewState = .genericError
                }
            case .failure(let error):
                print(error)
                self.viewState = .genericError
            }
        }
    }
    
    func loadGenreList() {
        let provider = MoyaProvider<MovieDB>()
        provider.request(.genreList) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    
                    genreList = try decoder.decode(GenreList.self, from: response.data)
                } catch {
                    print("Erro ao receber dados")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchMovies(named query: String) {
        if movieList != nil {
            movieList = nil
        }
        self.viewState = .loading
        let provider = MoyaProvider<MovieDB>()
        provider.request(.searchMovies(query: query)) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase //Convert JSON snake cases to variable camel case
                    
                    movieList = try decoder.decode(MovieList.self, from: response.data)
                    if movieList!.results.count > 0 {
                        self.viewState = .defaultScreen
                    } else {
                        self.viewState = .emptySearch
                    }
                } catch {
                    print("Erro ao receber dados")
                    self.viewState = .emptySearch
                }
            case .failure(let error):
                print(error)
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
            //cell.backgroundColor = .black
            cell.movieTitle.text = movie.title
            let data = try? Data(contentsOf: movie.imagePath)
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
        vc?.name = selectedMovie.title
        vc?.genre = self.idToGenreName(for: selectedMovie)
        vc?.releaseDate = selectedMovie.releaseDate
        vc?.overview = selectedMovie.overview
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
        
        self.searchMovies(named: query)
        
        return true
    }
    
    
}
