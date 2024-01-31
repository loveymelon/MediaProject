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
    
    var popularData: [PopularMovies] = []
    var trendData: [TrendTV] = []
    var topData: [TopRates] = []
    
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        group.enter()
        TMDBAPIManager.shared.fetchPopularMovie { result in
//            MovieModel.popular = result
            self.popularData = result
            self.group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchTrendingTV { result in
//            MovieModel.trend = result
            self.trendData = result
            self.group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchTopRate { result in
//            MovieModel.top = result
            self.topData = result
            self.group.leave()
        }
        
        group.notify(queue: .main) {
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
            number = popularData.count
        case 1:
            number = trendData.count
        case 2:
            number = topData.count
        default:
            print("error")
        }
        
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        if collectionView.tag == 0 {
            let item = popularData[indexPath.item]/*MovieModel.popular[indexPath.item]*/
            let url = URL(string: "\(baseUrl)\(item.posterPath ?? "a")")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.name
        } else if collectionView.tag == 1 {
            let item = trendData[indexPath.item]/*MovieModel.trend[indexPath.item]*/
            let url = URL(string: "\(baseUrl)\(item.posterPath)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.name
        } else if collectionView.tag == 2 {
            let item = topData[indexPath.item]/*MovieModel.top[indexPath.item]*/
            let url = URL(string: "\(baseUrl)\(item.posterPath!)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.title
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = TVDetailViewController()
        print(#function)
        if collectionView.tag == 0 {
            detailVC.id = popularData[indexPath.item].id
        } else if collectionView.tag == 1 {
            detailVC.id = topData[indexPath.item].id
        } else {
            detailVC.id = trendData[indexPath.item].id
        }
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
