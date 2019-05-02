
import Foundation

enum AccountStatesMovieKey: String, CodingKey {
    case id = "id"
}

struct AccountStates: Codable  {
    
    var id:Int
    var favorite: Bool
    var rated: Bool
    var watchlist: Bool
    
    static func initWith(data: Data) -> AccountStates? {
        do {
            return try JSONDecoder().decode(self, from: data)
        }catch let error {
            print(error)
            return nil
        }
    }
    
}
