
import Foundation
import Moya

class MovieService {
    
    
    static let provider = MoyaProvider<MovieAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    
    static func genre(completion: @escaping (GenreList?)->()) {
        
        provider.request(.genre()) { result in
            
            switch result {
            case let .success(response):
                let genreList = GenreList.initWith(data: response.data)
                completion(genreList)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
//                completion(nil)
            }
        }
    }
    
    static func upcoming(page: Int, completion: @escaping (MovieList?)->()) {
        
        provider.request(.upcoming(page: page)) { result in
            
            switch result {
            case let .success(response):
                let movies = MovieList.initWith(data: response.data)
                completion(movies)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
//                completion(nil)
            }
        }
    }
    
    static func popular(page: Int, completion: @escaping (MovieList?)->()) {
        
        provider.request(.popular(page: page)) { result in
            
            switch result {
            case let .success(response):
                let movies = MovieList.initWith(data: response.data)
                completion(movies)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
                //                completion(nil)
            }
        }
    }
    
    static func search(query: String, completion: @escaping (MovieList?)->()) {
        
        provider.request(.search(query: query)) { result in
            switch result {
            case let .success(response):
                let movies = MovieList.initWith(data: response.data)
                completion(movies)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
                //                completion(nil)

            }
        }
    }
    
    static func accountStates(movie_id: Int, completion: @escaping (AccountStates?)->()) {
        provider.request(.accountSates(movie_id: movie_id)) { result in
            switch result {
            case let .success(response):
                let accountStates = AccountStates.initWith(data: response.data)
                completion(accountStates)
            case let .failure(error):
                print(error)
                // TODO: error handler callback
                //                completion(nil)
            }
        }
    }

    
    static func smallCoverUrl(movie: Movie) -> URL? {
        guard let path = movie.poster_path else{ return nil }
        if let url = URL(string: MovieAPI.smallImagePath + path) {
            return url
        }
        return nil
    }
    
    static func bigCoverUrl(movie: Movie) -> URL? {
        guard let path = movie.poster_path else{ return nil }
        if let url = URL(string: MovieAPI.bigImagePath + path) {
            return url
        }
        return nil
    }
    
    
}
