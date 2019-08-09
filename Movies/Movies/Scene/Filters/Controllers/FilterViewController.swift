//
//  FilterViewController.swift
//  Movies
//
//  Created by Alexandre Thadeu on 08/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    private let dataSource = FilterDataSource()
    
    lazy var viewModel: FilterViewModel = {
        return FilterViewModel(dataSource: dataSource)
    }()
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            let cell = UINib(nibName: "FilterGenreCollectionViewCell", bundle: nil)
            collectionView.register(cell, forCellWithReuseIdentifier: Identifiers.CollectionCell.genreFilterCell.rawValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI()
        self.configBinds()
        self.viewModel.getGenres()
        // Do any additional setup after loading the view.
    }
    
    func configUI() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
    }
    
    func configBinds() {
        self.viewModel.datasource?.data.addAndNotify(observer: self) { [weak self] in
            self?.collectionView.reloadData()
            
            if let genres = self?.viewModel.datasource?.data.value, genres.count > 0 {
                self?.collectionView.restore()
                self?.collectionView.reloadData()
            } else {
                self?.collectionView.setEmptyMessage("Não foi possível carregar os gêneros, tente novamente.")
            }
        }
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFiltersAction(_ sender: Any) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
