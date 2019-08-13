//
//  MoviesCollectionViewControllerSpec.swift
//  movieAppTests
//
//  Created by Matheus Azevedo on 12/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Quick
import Nimble

@testable import movieApp

class MoviesCollectionViewControllerSpec: QuickSpec {
    override func spec() {
        var testView: MoviesCollectionViewController!
        var movie: Movie!
        var validMovieList: MovieList!
        
        describe("loading popular movies") {
            beforeEach {
                movie = Movie(id: 111111, title: "TituloTeste", releaseDate: "2000-00-00", genreIds: [0], overview: "lorem ipsum", posterPath: nil)
                validMovieList = MovieList(results: [movie])
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                testView = storyboard.instantiateViewController(withIdentifier: "MoviesCollectionViewControllerID") as? MoviesCollectionViewController
                testView.requester = MockMovieRequester()
            }
            context("when it succeds") {
                it("should change view to default state"){
                    expect({
                        guard case .loading = testView.actualViewState() else {
                            return .failed(reason: "wrong enum case.")
                        }
                        return .succeeded
                    }).to(succeed())
                    
                    (testView.requester as! MockMovieRequester).success = true
                    (testView.requester as! MockMovieRequester).movieList = validMovieList
                    let _ = testView.view //Trigger the view
                    
                    expect({
                        guard case .defaultScreen = testView.actualViewState() else {
                            return .failed(reason: "wrong enum case.")
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            
            context("when it fails") {
                it("should change view to generic error state"){
                    expect({
                        guard case .loading = testView.actualViewState() else {
                            return .failed(reason: "wrong enum case.")
                        }
                        return .succeeded
                    }).to(succeed())
                    
                    (testView.requester as! MockMovieRequester).success = false
                    let _ = testView.view //Trigger the view
                    
                    expect({
                        guard case .genericError = testView.actualViewState() else {
                            return .failed(reason: "wrong enum case.")
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
        
        describe("searching movies") {
            beforeEach {
                movie = Movie(id: 111111, title: "TituloTeste", releaseDate: "2000-00-00", genreIds: [0], overview: "lorem ipsum", posterPath: nil)
                validMovieList = MovieList(results: [movie])
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                testView = storyboard.instantiateViewController(withIdentifier: "MoviesCollectionViewControllerID") as? MoviesCollectionViewController
                testView.requester = MockMovieRequester()
                let _ = testView.view //Trigger the view
            }
            
            context("when the search find movies") {
                it("should change view to default state") {
                    
                    (testView.requester as! MockMovieRequester).success = true
                    (testView.requester as! MockMovieRequester).movieList = validMovieList
                    testView.searchMovies("string")
                    
                    expect({
                        guard case .defaultScreen = testView.actualViewState() else {
                            return .failed(reason: "wrong enum case.")
                        }
                        return .succeeded
                    }).to(succeed())
                }
                it("should create as much cells as the number of movies") {
                    expect(testView.collectionView.numberOfItems(inSection: 0)).to(equal(0))
                    
                    (testView.requester as! MockMovieRequester).success = true
                    (testView.requester as! MockMovieRequester).movieList = validMovieList
                    testView.searchMovies("string")
                    
                    expect(testView.collectionView.numberOfItems(inSection: 0)).to(equal(1))
                }
            }
            
            context("when the search results are empty") {
                let emptyMovieList = MovieList(results: [])
                
                it("should change view to 'empty search' state") {
                    (testView.requester as! MockMovieRequester).success = true
                    (testView.requester as! MockMovieRequester).movieList = emptyMovieList
                    testView.searchMovies("string")
                    
                    expect({
                        guard case .emptySearch = testView.actualViewState() else {
                            return .failed(reason: "wrong enum case.")
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
}


//Mock class for test using MovieRequester
class MockMovieRequester: MovieDBRequestProtocol {
    var success: Bool = true
    var movieList: MovieList?
    var genreList: GenreList?
    
    func getPopularMovies(completion: @escaping (Bool, MovieList?) -> ()) {
        completion(success, movieList)
    }
    
    func getSearchedMovies(named query: String, completion: @escaping (Bool, MovieList?) -> ()) {
        completion(success, movieList)
    }
    
    func getGenreList(completion: @escaping (Bool, GenreList?) -> ()) {
        
    }
    
    
}
