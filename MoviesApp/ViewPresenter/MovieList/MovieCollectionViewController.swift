//
//  MovieCollectionViewController.swift
//  MoviesApp
//
//  Created by fgrmac on 01/08/19.
//  Copyright © 2019 Fulvio Resendes. All rights reserved.
//

import UIKit
import Disk


class MovieCollectionViewController: UICollectionViewController {
    
    //var indexPathCell: IndexPath?
    
    
    private let presenter = MovieListPresenter()
    
    private let reuseIdentifier = "PopularGridCell"
    private let sectionInsets = UIEdgeInsets(top: 25.0, left: 10.0, bottom: 50.0, right: 10.0)
    private let itemsPerRow: CGFloat = 2
    
    var tableData: [Movie]?
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.setView(view: self)
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.searchBar.placeholder = "Buscar um filme"
        searchController.searchBar.sizeToFit()
        searchController.searchBar.becomeFirstResponder()
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.reloadData()
        
        self.presenter.loadGenreAndMovies()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "MovieContentDetail", sender: indexPath)

    }
    
    
    // MARK: SearchController
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText (_ searchText: String, scope: String = "All") {
        
        if !searchText.isEmpty {
            self.presenter.movies = nil
            self.presenter.search(query: searchText)
        } else {
            self.presenter.isLoading = false
            self.presenter.movies = nil
            self.presenter.loadGenre()
            
        }
        
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    // MARK: Button Actions
    @IBAction func favButtonTapped(sender: UIButton) -> Void {
        let index = sender.tag
        if let movie = self.tableData?[index] {
            if Disk.exists("favorite.json", in: .applicationSupport) {
                var fav = try? Disk.retrieve("favorite.json", from: .applicationSupport, as: [Movie].self)
                if (fav?.index{ $0.id == movie.id}) != nil {
                    fav?.removeAll{$0.id == movie.id}
                    try? Disk.save(fav, to: .applicationSupport, as: "favorite.json")
                } else {
                    try? Disk.append([movie], to: "favorite.json", in: .applicationSupport)
                }
            } else {
                try? Disk.save([movie], to: .applicationSupport, as: "favorite.json")
            }
        }
        self.collectionView?.reloadData()       
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let index = sender as? NSIndexPath,
            let movie = self.tableData?[index.item],
            let destination = segue.destination as? MovieDetailView  {
                destination.setMovie(movie: movie)
            }
    }
    
    
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.tableData?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularGridCell", for: indexPath) as! MovieCollectionCell
        let favButton = UIButton(frame: CGRect(x: 142, y: 140, width: 40, height: 40))
        
        favButton.addTarget(self, action: #selector(favButtonTapped), for: UIControlEvents.touchUpInside)
        favButton.tag = indexPath.item
        favButton.isUserInteractionEnabled = true
        
        cell.addSubview(favButton)

        // print statments shows that the movies are favorited correctly in the file but the cells are shown incorrectly. Possible XCode bug
        if let movie = tableData?[indexPath.item] {
            cell.movieLabel.text = movie.title
            cell.movieImageView.image = nil
            if movie.favorited {
                //print("Favorite movie saved \(movie.title)")
                favButton.setImage(UIImage(named: favIcon.favorite), for: UIControlState.normal)
            } else {
                favButton.setImage(UIImage(named: favIcon.unfavorite), for: UIControlState.normal)
            }

            if let imageURL = MovieService.smallCoverUrl(movie: movie) {
                cell.movieImageView.load(url: imageURL)
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.presenter.canLoadMore(indexPath: indexPath) {
            self.presenter.loadNextPage()
        }
    }
    
}

extension MovieCollectionViewController: MovieListView {
    
    func finishLoading(movies: [Movie]) {
        self.tableData = movies
        self.collectionView?.reloadData()
        // TODO: add callback for error!!!
    }
    
}

extension MovieCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension MovieCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
}
