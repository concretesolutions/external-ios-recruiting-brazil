//
//  DatabaseManagerSpec.swift
//  movieAppTests
//
//  Created by Matheus Azevedo on 12/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import Quick
import Nimble
import RealmSwift

@testable import movieApp

class DatabaseManagerSpec: QuickSpec {
    override func spec() {
        describe("favoriting a movie") {
            var testDatabaseManager: DatabaseManager!
            var movie: Movie!
            
            beforeEach {
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                testDatabaseManager = try! DatabaseManager.init(realm: Realm())
                movie = Movie(id: 111111, title: "TituloTeste", releaseDate: "2000-00-00", genreIds: [0], overview: "lorem ipsum", posterPath: nil)
            }
            
            afterEach {
                try! testDatabaseManager.realm.write {
                    testDatabaseManager.realm.deleteAll()
                }
            }
            
            it("should add to the Realm") {
                expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(0))
                testDatabaseManager.saveFavorite(movie)
                expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(1))
            }
            
            it("should write the correct info in Realm") {
                testDatabaseManager.saveFavorite(movie)
                let movieFromDatabase = testDatabaseManager.realm.objects(FavoritedMovie.self).last
                expect(movieFromDatabase?.id).to(equal(movie.id))
                expect(movieFromDatabase?.title).to(match(movie.title))
                expect(movieFromDatabase?.year).to(match(movie.year))
                expect(movieFromDatabase?.overview).to(match(movie.overview))
            }
            context("when the movie has been already saved") {
                it("should not save in Realm") {
                    testDatabaseManager.saveFavorite(movie)
                    let movieFromDatabase = testDatabaseManager.realm.objects(FavoritedMovie.self).last
                    expect(movieFromDatabase?.id).to(equal(movie.id))
                    
                    let savedMovies = testDatabaseManager.realm.objects(FavoritedMovie.self).count
                    testDatabaseManager.saveFavorite(movie)
                    expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(savedMovies))
                    
                }

            }
        }
        
        describe("delete a favorite") {
            var testDatabaseManager: DatabaseManager!
            var savedMovie1: Movie!
            var savedMovie2: Movie!
            
            beforeEach {
                Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
                testDatabaseManager = try! DatabaseManager.init(realm: Realm())
                savedMovie1 = Movie(id: 111111, title: "TituloTeste", releaseDate: "2000-00-00", genreIds: [0], overview: "lorem ipsum", posterPath: nil)
                savedMovie2 = Movie(id: 222222, title: "TituloTeste", releaseDate: "2000-00-00", genreIds: [0], overview: "lorem ipsum", posterPath: nil)
                
                testDatabaseManager.saveFavorite(savedMovie1)
                testDatabaseManager.saveFavorite(savedMovie2)
            }
            
            afterEach {
                try! testDatabaseManager.realm.write {
                    testDatabaseManager.realm.deleteAll()
                }
            }
            
            it("should remove from Realm") {
                expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(2))
                
                testDatabaseManager.deleteFavorite(id: savedMovie1.id)
                expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(1))
                
                testDatabaseManager.deleteFavorite(id: savedMovie2.id)
                expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(0))
            }
            
            context("when it doesn't exist in database") {
                it("should not remove anything from Realm") {
                    let newMovie = Movie(id: 333333, title: "TituloTeste", releaseDate: "2000-00-00", genreIds: [0], overview: "lorem ipsum", posterPath: nil)
                    
                    expect(testDatabaseManager.realm.object(ofType: FavoritedMovie.self, forPrimaryKey: newMovie.id)).to(beNil())
                    expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(2))
                    
                    testDatabaseManager.deleteFavorite(id: newMovie.id)
                    expect(testDatabaseManager.realm.objects(FavoritedMovie.self).count).to(equal(2))
                }
            }
            
        }
        
    }
}
