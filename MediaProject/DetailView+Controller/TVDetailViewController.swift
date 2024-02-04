//
//  TVDetailViewController.swift
//  MediaProject
//
//  Created by 김진수 on 1/31/24.
//

import UIKit
import SnapKit
import Kingfisher

class TVDetailViewController: BaseViewController {
    
    let mainView = DetailView()
    
    var id: Int?
    var castName = ""
    
    var recommendData: [RecommendTV] = []{
        didSet {
            mainView.tableView.reloadData()
        }
    }
    
    var dic: [String: Any] = [:]
    
    let dataKeys = ["credit", "recommend"]
    let group = DispatchGroup()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: TVDetailModel.self, api: .detail(id: id!)) { [self] result in
            dic["detail"] = result
            group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: CreditModel.self, api: .credit(id: id!)) { [self] result in
            dic[dataKeys[0]] = result
            group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: RecommendModel.self, api: .recommend(id: id!)) { [self] result in
            dic[dataKeys[1]] = result
            self.group.leave()
        }
        
        group.notify(queue: .main) { [self] in
            mainView.tableView.reloadData()
        }
    }
    
    override func configureView() {
        super.configureView()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        
    }
    
}

extension TVDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Helper.movieTableCellIdentifier, for: indexPath) as! MovieTableViewCell
        cell.movieCollectionView.delegate = self
        cell.movieCollectionView.dataSource = self
        cell.movieCollectionView.layer.name = dataKeys[indexPath.row]
        cell.movieCollectionView.register(MovieTableViewCell.self, forCellWithReuseIdentifier: Helper.movieTableCellIdentifier)
        cell.movieCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Helper.detailTableHeaderIdentifier) as! DetailTableViewHeaderView
        let data = dic["detail"] as! TVDetailModel
        
        headerView.configureHearder(item: data)
        
        return headerView
    }
}

extension TVDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let key = collectionView.layer.name else {
            return 0
        }
        
        if let data = dic[key] as? CreditModel {
            return data.cast.count
        } // 여기부터 수정해야됨
        
        return recommendData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        let data = recommendData[indexPath.item]
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath)")
        
        cell.mainImageView.kf.setImage(with: url)
        cell.imageLabel.text = data.name
        
        return cell
    }
    
}


    
