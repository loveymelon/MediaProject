//
//  MainViewController.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import UIKit
import SnapKit
import Kingfisher

class MainViewController: UIViewController {

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UIScreen.main.bounds.height / 3
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Helper.movieTableCellIdentifier)
        return tableView
    }()
    
    let titleArray = ["Popular", "Top Rate", "Trending"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        TMDBAPIManager.shared.fetchPopularMovie { result in
            MovieModel.popular = result
            self.tableView.reloadData()
        }
        
        TMDBAPIManager.shared.fetchTrendingTV { result in
            MovieModel.trend = result
            print(MovieModel.trend)
            self.tableView.reloadData()
        }
        
        TMDBAPIManager.shared.fetchTopRate { result in
            MovieModel.top = result
            self.tableView.reloadData()
        }
    }
    
}

extension MainViewController: ConfigureUIProtocol {
    
    func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        self.view.addSubview(tableView)
    }
    
    func configureLayout() {
        self.tableView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .black
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Helper.movieTableCellIdentifier, for: indexPath) as! MovieTableViewCell
        let categoryData = titleArray[indexPath.row]
        
        cell.configureCell(data: categoryData)
        cell.movieCollectionView.tag = indexPath.row
        cell.movieCollectionView.dataSource = self
        cell.movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Helper.movieCollectionCellIdentifier)
        cell.movieCollectionView.delegate = self
        cell.movieCollectionView.reloadData()
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = 0
        
        switch collectionView.tag {
        case 0:
            number = MovieModel.popular.count
        case 1:
            number = MovieModel.trend.count
        case 2:
            number = MovieModel.top.count
        default:
            print("error")
        }
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        if collectionView.tag == 0 {
            let item = MovieModel.popular[indexPath.item]
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(item.posterPath!)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.name
        } else if collectionView.tag == 1 {
            let item = MovieModel.trend[indexPath.item]
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(item.posterPath)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.name
        } else if collectionView.tag == 2 {
            let item = MovieModel.top[indexPath.item]
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(item.posterPath!)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.title
        }
        return cell
    }
    
}
