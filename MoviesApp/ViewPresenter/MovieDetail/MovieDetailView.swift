
import UIKit
import Disk

protocol MovieDetailView: NSObjectProtocol {
    func setMovie(movie: Movie)
    func updateView(title: String, date: String, genre: String, overview: String)
    func loadImage(url: URL)
}

class MovieDetailViewController: UIViewController {
    
    private let presenter = MovieDetailPresenter()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.setView(view: self)
        self.presenter.showMovie()
        
        if !Disk.exists("favorite.json", in: .applicationSupport) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addTapped))
        } else {
            do {
                let retrievedFavorites = try Disk.retrieve("favorite.json", from: .applicationSupport, as: [Movie].self)
                let found = retrievedFavorites.filter {
                    $0.id == self.presenter.movie.id
                }
                if found.isEmpty {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(addTapped))
                } else {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addTapped))
                }
            } catch {
                print(error.localizedDescription)
            }
        }

        
        // TODO: add scrolls
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func addTapped() {
        
        if Disk.exists("favorite.json", in: .applicationSupport) {
            var fav = try? Disk.retrieve("favorite.json", from: .applicationSupport, as: [Movie].self)
            if (fav?.index{ $0.id == self.presenter.movie.id}) != nil {
                fav?.removeAll{$0.id == self.presenter.movie.id}
                try? Disk.save(fav, to: .applicationSupport, as: "favorite.json")
            } else {
                try? Disk.append([self.presenter.movie], to: "favorite.json", in: .applicationSupport)
            }
        } else {
            try? Disk.save([self.presenter.movie], to: .applicationSupport, as: "favorite.json")
        }

        _ = navigationController?.popViewController(animated: true)
        
    }
    
}

extension MovieDetailViewController: MovieDetailView {
    
    func setMovie(movie: Movie) {
        self.presenter.movie = movie
    }
    
    func updateView(title: String, date: String, genre: String, overview: String) {
        self.title = title
        self.titleLabel.text = title
        self.dateLabel.text = date.formattedDateFromString(dateString: date, withFormat: "dd/MM/yyyy")
        self.genreLabel.text = genre
        self.overviewLabel.text = overview        
    }
    
    func loadImage(url: URL) {
        self.coverImageView.load(url: url)
    }
    
}
