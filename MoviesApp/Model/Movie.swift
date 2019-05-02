
import Foundation
import Disk

enum MovieKey: String, CodingKey {
    case id = "id"
    case title = "title"
}

struct Movie: Codable  {
    
    var id:Int
    var title: String
    var poster_path: String?
    var backdrop_path: String?
    var release_date: String
    var overview: String
    var genre_ids: [Int]
    
    var genres: [String] {
        let filter: [Genre]? = GenreList.shared?.filter({ (genre) -> Bool in
            genre_ids.contains(genre.id)
        })
        let names = filter?.map({ (genre) -> String in
            genre.name
        })
        return names ?? []
    }
    var genresString: String {
        return self.genres.joined(separator: ", ")
    }
    
    var localizedReleaseDate: String {
        return self.release_date.formattedDateFromString(dateString: self.release_date, withFormat: "dd/MM/yyyy")
        
    }
    
    var favorited: Bool {

        get{
            let fav = try? Disk.retrieve("favorite.json", from: .applicationSupport, as: [Movie].self)
            if (fav?.index{ $0.id == self.id}) != nil {
                return true
            } else {
                return false
            }
        }
        set {
            return
        }
    }
}
