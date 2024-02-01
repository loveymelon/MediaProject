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
    
    let mainView = MainView()

    var contentsData: [ContentsModel] = [
        ContentsModel(results: []),
        ContentsModel(results: []),
        ContentsModel(results: [])
    ]
    var topData: [TopRates] = []
    
    let group = DispatchGroup()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(api: .popular) { result in
            self.contentsData.append(result)
            self.group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(api: .trendingTV) { result in
            self.contentsData.append(result)
            self.group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchTopRate(api: .topRate) { result in
            self.topData = result
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            self.mainView.tableView.reloadData()
        }
    }
    
    func tableViewSetting() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainView.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Helper.movieTableCellIdentifier, for: indexPath) as! MovieTableViewCell
        let categoryData = mainView.titleArray[indexPath.row]
        
        cell.configureCell(data: categoryData)
        cell.movieCollectionView.tag = indexPath.row
        print(cell.movieCollectionView.tag)
        cell.movieCollectionView.dataSource = self
        cell.movieCollectionView.delegate = self
        cell.movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Helper.movieCollectionCellIdentifier)
        print(#function)
        cell.movieCollectionView.reloadData()
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(#function)
        if collectionView.tag < 2{
            return contentsData[collectionView.tag].results.count
        } else {
            return topData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        print(#function)
        if collectionView.tag < 2 {
            let item = contentsData[collectionView.tag].results[indexPath.item]
    
            guard let posterData = item.posterPath else {
                cell.mainImageView.image = UIImage(systemName: "xmark")
                cell.imageLabel.text = item.name
                return cell
            }
            
            let url = URL(string: baseUrl + "\(posterData)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.name
        } else {
            let item = topData[indexPath.item]
            
            guard let posterData = item.posterPath else {
                cell.mainImageView.image = UIImage(systemName: "xmark")
                cell.imageLabel.text = item.title
                return cell
            }
            
            let url = URL(string: "\(baseUrl)\(item.posterPath!)")
            cell.mainImageView.kf.setImage(with: url)
            cell.imageLabel.text = item.title
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = TVDetailViewController()
        if collectionView.tag == 0 {
            detailVC.id = contentsData[collectionView.tag].results[indexPath.item].id
        } else {
            detailVC.id = topData[indexPath.item].id
        }
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
