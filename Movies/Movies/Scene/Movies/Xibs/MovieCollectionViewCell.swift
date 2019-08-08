//
//  MovieCollectionViewCell.swift
//  Movies
//
//  Created by Alexandre Thadeu on 06/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    
    private var genreLocal = SwinjectContainer.container.resolve(GenreLocal.self)!
    private var movieLocal = SwinjectContainer.container.resolve(MovieLocal.self)!
    private var movie: Movie?
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieFavouriteButton: UIButton!
    @IBOutlet weak var genre1View: UIView! {
        didSet {
            genre1View.layer.cornerRadius = 5.0
            genre1View.backgroundColor = UIColor.MovieBaseColors.yellow
        }
    }
    @IBOutlet weak var genre1Label: UILabel!
    @IBOutlet weak var genre2View: UIView! {
        didSet {
            genre2View.layer.cornerRadius = 5.0
            genre2View.backgroundColor = UIColor.MovieBaseColors.yellow
        }
    }
    @IBOutlet weak var genre2Label: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var favouriteIconImageView: UIImageView!
    
    
    func configCell(movie: Movie) {
        self.movie = movie
        if let posterPath = movie.posterPath {
            downloadImage(url: ImageRouter.getImage(imageString: posterPath).url)
        }
        
        if let genresId = movie.genresId {
            setGenres(genresId: genresId)
        }
        
        if hasFavourite() {
            setFavouriteButton()
        } else {
            unSetFavouriteButton()
        }
        
        movieTitleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        
    }
    
    func hasFavourite() -> Bool {
        do {
            let favouriteMovies = try movieLocal.fetchMovies()
            
            if let movie = self.movie, favouriteMovies.count > 0, favouriteMovies.contains(where: { $0.movieId == movie.movieId }) {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
        
    
    func downloadImage(url: URL) {
        moviePosterImageView.kf.indicatorType = .activity
        moviePosterImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "emptyPoster"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success:
                break
            case .failure(let error):
                NSLog("Erro ao baixar a image: \(error.localizedDescription)")
            }
        }
    }
    
    func setGenres(genresId: [Int]) {
        do {
            let genres = try genreLocal.fetchGenres(genresId: genresId)
            
            if genres.count >= 2 {
                let genre1 = genres[0], genre2 = genres[1]
                
                genre1View.isHidden = false
                genre2View.isHidden = false
                
                genre1Label.text = genre1.name
                genre2Label.text = genre2.name
                
            } else if genres.count == 1 {
                let genre1 = genres[0]
                
                genre2View.isHidden = true
                genre1View.isHidden = false
                
                genre1Label.text = genre1.name
            } else {
                genre1View.isHidden = true
                genre2View.isHidden = true
            }
        } catch let error {
            genre1View.isHidden = true
            genre2View.isHidden = true
            NSLog("Erro ao tentar pegar o genêros: %@", error.localizedDescription)
        }
    }
    
    func setFavouriteButton() {
        favouriteIconImageView.isHighlighted = true
        movieFavouriteButton.isSelected = true
    }
    
    func unSetFavouriteButton() {
        favouriteIconImageView.isHighlighted = false
        movieFavouriteButton.isSelected = false
    }
    
    @IBAction func favouriteButtonAction(_ sender: Any) {
        if movieFavouriteButton.isSelected {
            unSetFavouriteButton()
            guard let movie = self.movie else { return }
            
            do {
                try movieLocal.deleteMovie(movieId: movie.movieId)

            } catch let error {
                NSLog("Erro ao tentar desfavoritar o filme: %@", error.localizedDescription)

            }
        } else {
            setFavouriteButton()
            
            guard let movie = self.movie else { return }
            
            do {
                try movieLocal.insertMovie(movie: movie)
                
            } catch let error {
                NSLog("Erro ao tentar favoritar o filme: %@", error.localizedDescription)
                
            }
        }
    }
    
}
