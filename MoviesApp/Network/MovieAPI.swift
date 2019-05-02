
import Foundation
import Moya

enum MovieAPI {
    case upcoming(page: Int)
    case movie(id: Int)
    case genre()
    case popular(page: Int)
    case accountSates(movie_id: Int)
    case search(query: String)
}

extension MovieAPI: TargetType {
    
    var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }
    var apiKey: String {return "4f1d2db513353592d53670868fe138be"}
    var session_id: String {return "5d9b6ef19cc3ce305de30cbf8a79619a25a44471"}
    
    static let smallImagePath = "https://image.tmdb.org/t/p/w185"
    static let bigImagePath = "https://image.tmdb.org/t/p/w342"
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    var path: String {
        switch self {
            case .upcoming(_):
                return "/movie/upcoming"
            case .movie(let id):
                return "/movie/\(id)"
            case .genre():
                return "/genre/movie/list"
            case .popular(_):
                return "/movie/popular"
            case .accountSates(let movie_id):
                return "/movie/\(movie_id)/account_states"
            case .search(_):
                return "/search/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .upcoming(_), .movie(_), .genre(), .popular(_), .accountSates(_), .search(_):
            return .get
        }
    }
    
    var task: Task {
        var params = ["api_key": apiKey]
        switch self {
        case .upcoming(let page), .popular(let page):
            params["page"] = "\(page)"
            params["language"] = "pt-BR"
            params["region"] = "BR"
            break
        case .movie(_), .genre():
            params["language"] = "pt-BR"
            params["region"] = "BR"
            break
        case .accountSates(let movie_id):
            params["session_id"] = session_id
            params["movie_id"] = "\(movie_id)"
            break
        case .search(let query):
            params["query"] = query
            params["language"] = "pt-BR"
            params["page"] = "1"
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .upcoming(_), .movie(_), .genre(), .popular(_), .accountSates(_), .search(_):
            return URLEncoding.queryString
        }
    }
    
    var sampleData: Data {
        var filename: String
        switch self {
        case .upcoming:
            filename = "upcoming"
            break
        case .movie(_):
            filename = "movie353081"
            break
        case .popular:
            filename = "popular"
            break
        case .genre:
            filename = "genre" // TODO
            break
        case .accountSates:
            filename = "account_states"
            break
        case .search(_):
            filename = "search"
            break
        }
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return Data()
        }
        return data
    }
    
}
