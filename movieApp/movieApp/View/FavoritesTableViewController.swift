//
//  FavoritesTableViewController.swift
//  movieApp
//
//  Created by Matheus Azevedo on 11/08/19.
//  Copyright © 2019 Matheus Azevedo. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FavoriteCell"
private var movies = [FavoritedMovie]()

class FavoritesTableViewController: UITableViewController {


    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        movies = DatabaseManager.shared.getSavedFavorites()
        warningLabel.isHidden = willHideWarningLabel()
        self.tableView.reloadData()
    }
    
    ///Defines if the warning label should appears
    func willHideWarningLabel() -> Bool{
        if movies.count <= 0 {
            return false
        } else {
            return true
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoritesTableViewCell

        // Configure the cell
        let movie = movies[indexPath.row]
        
        let imageUrl = URL(string: movie.imagePath)!
        let data = try? Data(contentsOf: imageUrl)
        if let imageData = data {
            cell.movieImage.image = UIImage(data: imageData)
        } else {
            cell.movieImage.image = UIImage(imageLiteralResourceName: "no_image_available_icon.jpg")
        }
        
        cell.movieTitle.text = movie.title
        cell.movieYear.text = movie.year
        cell.movieOverview.text = movie.overview
        

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DatabaseManager.shared.deleteFavorite(id: movies[indexPath.row].id)
            movies.remove(at: indexPath.row)
            warningLabel.isHidden = willHideWarningLabel()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Do nothing
        }    
    }
 
}
