//
//  MainViewController.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import UIKit

final class MainViewController: BaseViewController {
    
    private let mainView = MainView()
    
    private var dic: [String: Decodable] = [:]
    private var apiArray: [TMDBAPI] = [.popular, .topRate, .trendingTV]
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetting()
        sessionNetworking()
        
    }
    
    override func networkingData() {
        for (index, api) in apiArray.enumerated() {
            group.enter()
            
            TMDBAPIManager.shared.fetchContents(type: ContentsModel.self, api: api) { [self] result, error  in
                dic[mainView.titleArray[index]] = result
                
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [self] in
            mainView.tableView.reloadData()
        }
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
        cell.movieCollectionView.layer.name = mainView.titleArray[indexPath.item]
        cell.movieCollectionView.dataSource = self
        cell.movieCollectionView.delegate = self
        cell.movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Helper.movieCollectionCellIdentifier)
        cell.movieCollectionView.reloadData()
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let key = collectionView.layer.name else {
            return 0
        }
        
        guard let data = dic[key] as? ContentsModel else {
            return 0
        }
        
        return data.results.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        
        guard let data = dic[collectionView.layer.name!] as? ContentsModel else { return cell }
        
        let item = data.results[indexPath.item]
        
        cell.configureContentsCell(item: item)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = TVDetailViewController()
        
        guard let item = dic[collectionView.layer.name!] as? ContentsModel else { return }
        
        if collectionView.layer.name == mainView.titleArray[1] {
            detailVC.movie = true
        } else {
            detailVC.movie = false
        }
        
        detailVC.id = item.results[indexPath.item].id
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension MainViewController {
    private func tableViewSetting() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func sessionNetworking() {
        for (index, api) in apiArray.enumerated() {
            group.enter()
            
            TMDBSessionAPIManager.shared.fetchContetns(type: ContentsModel.self, api: api) { [self] result, error in
                dic[mainView.titleArray[index]] = result
                group.leave()
            }
            
            group.notify(queue: .main) { [self] in
                mainView.tableView.reloadData()
            }
        }
    }
}
