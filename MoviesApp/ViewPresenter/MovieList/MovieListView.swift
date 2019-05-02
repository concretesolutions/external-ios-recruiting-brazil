
import UIKit
import Disk

protocol MovieListView: NSObjectProtocol {
    func finishLoading(movies: [Movie])
}


class MovieListViewController: UITableViewController {
    
    private let presenter = MovieListPresenter()
    
    var tableData: [Movie]?
    
    let searchController = UISearchController(searchResultsController: nil)
    //var filteredMovies: [Movie]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter.setView(view: self)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellReuseIdentifier: "MovieListCell")
        
        //Setup the Search Controller
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Search Movie"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
        
        //debugPrint("Popular view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        
        //debugPrint("Popular will appear")
        self.presenter.loadGenreAndMovies()
        
        // TODO: add loading view
        // TODO: error handler and alerts / retry
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText (_ searchText: String, scope: String = "All") {

        //            filteredMovies = (tableData?.filter({ (movie: Movie) -> Bool in
        //                return movie.title.lowercased().contains(searchText.lowercased())
        //            }))!
        //            tableView.reloadData()

        if !searchText.isEmpty {
            //self.presenter.isFiltering = true
            self.presenter.movies = nil
            self.presenter.search(query: searchText)
        } else {
            debugPrint("Search text está vazio")
            //self.presenter.isFiltering = false
            self.presenter.isLoading = false
            self.presenter.movies = nil
            self.presenter.loadGenre()
            
        }
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    // MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "movieDetailSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.presenter.canLoadMore(indexPath: indexPath) {
            self.presenter.loadNextPage()
        }
    }
    
    //Slide to favorite
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
        let action = UIContextualAction(style: .normal, title: "Favorite", handler: { (action, view, completionHandler) in
            var movie = self.tableData?[indexPath.row]
            
            //if self.isFiltering() {
            //    movie = self.filteredMovies?[indexPath.row]
            //}
            if Disk.exists("favorite.json", in: .applicationSupport) {
                
                let fav = try? Disk.retrieve("favorite.json", from: .applicationSupport, as: [Movie].self)
                if (fav?.index{ $0.id == movie?.id}) == nil {
                    movie?.favorited = true
                    try? Disk.append([movie], to: "favorite.json", in: .applicationSupport)
                }
                
            } else {
                movie?.favorited = true
                try? Disk.save([movie], to: .applicationSupport, as: "favorite.json")
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        })
        
        action.backgroundColor = UIColor.blue
        let configuration = UISwipeActionsConfiguration(actions: [action])
        return configuration
    }
    
    
    //Slide to delete
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Unfavorite") { (action, sourceView, completionHandler) in
            var deleteMovie: Movie?
            deleteMovie = self.tableData?[indexPath.row]
            self.tableData?[indexPath.row].favorited = false
            
            //if self.isFiltering() {
            //    if (self.filteredMovies?[indexPath.row]) != nil {
            //        deleteMovie = self.filteredMovies![indexPath.row]
            //        self.filteredMovies![indexPath.row].favorited = false
            //        if let index = self.tableData?.index(where: {$0.id == deleteMovie?.id}) {
            //            self.tableData?[index].favorited = false
            //        }
            //    }
            //    else { return }
            //}
            if Disk.exists("favorite.json", in: .applicationSupport) {
                
                var fav = try? Disk.retrieve("favorite.json", from: .applicationSupport, as: [Movie].self)
                if (fav?.index{ $0.id == deleteMovie?.id}) != nil {
                    fav?.removeAll{$0.id == deleteMovie?.id }
                    try? Disk.save(fav, to: .applicationSupport, as: "favorite.json")
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    completionHandler(true)
                } else {
                    completionHandler(false)
                }
            } else {
                completionHandler(false)
            }
            print("index path of delete: \(indexPath)")
        }
        delete.backgroundColor = UIColor.red
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        return swipeActionConfig
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        //if isFiltering() {
        //    if let index = self.tableView.indexPathForSelectedRow?.row {
        //        if let destination = segue.destination as? MovieDetailView {
        //            if let movie = self.filteredMovies?[index] {
        //                destination.setMovie(movie: movie)
        //            }
        //        }
        //    }
        //    return
        //}

        if let index = self.tableView.indexPathForSelectedRow?.row,
            let movie = self.tableData?[index]
        {
            if let destination = segue.destination as? MovieDetailView {
                destination.setMovie(movie: movie)
            }
        }

        
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if isFiltering() {
        //    return filteredMovies?.count ?? 0
        //}
        
        return self.tableData?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MovieListCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        
        //if isFiltering() {
        //    if let movie = filteredMovies?[indexPath.row] {
        //        showMovieIn(cell: cell, movie: movie)
        //    }
        //
        //} else {
        
            if let movie = tableData?[indexPath.row] {
                showMovieIn(cell: cell, movie: movie)
            }
            
        //}
        
        return cell
    }
    
    func showMovieIn(cell: MovieListCell, movie: Movie) {
        cell.titleLabel.text = movie.title
        cell.dateLabel.text = movie.localizedReleaseDate
        cell.genreLabel.text = movie.genresString
        
        cell.coverImageView.image = nil
        if let imageURL = MovieService.smallCoverUrl(movie: movie) {
            cell.coverImageView.load(url: imageURL)
        }
        
        if movie.favorited {
            cell.backgroundColor = .lightGray
        } else {
            cell.backgroundColor = .clear
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
}

extension MovieListViewController: MovieListView {
    
    func finishLoading(movies: [Movie]) {
        self.tableData = movies
        self.tableView.reloadData()
        // TODO: add callback for error!!!
    }
    
}
