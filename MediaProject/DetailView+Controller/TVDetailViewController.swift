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
    var movie: Bool = false
    
    var dic: [String: DetailModels] = [:]
    
    let dataKeys = ["cast", "crew", "recommend"]
    let group = DispatchGroup()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: TVDetailModel.self, api: .detail(id: id!, movie: movie)) { [self] result in
            dic["detail"] = .detail(data: result)
            group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: CreditModel.self, api: .credit(id: id!, movie: movie)) { [self] result in
            dic[dataKeys[0]] = .cast(data: result.cast)
            dic[dataKeys[1]] = .crew(data: result.crew)
            group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: RecommendModel.self, api: .recommend(id: id!, movie: movie)) { [self] result in
            dic[dataKeys[2]] = .recommend(data: result)
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
        cell.movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Helper.movieCollectionCellIdentifier)
        cell.movieCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Helper.detailTableHeaderIdentifier) as! DetailTableViewHeaderView
        
        if dic["detail"] == nil {
            return headerView
        }
        
        let data = dic["detail"]?.data as! TVDetailModel
        
        headerView.configureHearder(item: data)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 3
    }
}

extension TVDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let key = collectionView.layer.name else {
            return 0
        }
        
        return dic[key]?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        guard let key = collectionView.layer.name else { return cell }
        var tempData = dic[key]?.data
        
        switch key {
        case dataKeys[0]:
            let data = tempData as! [CastModel]
            cell.configureCastCell(item: data[indexPath.item])
        case dataKeys[1]:
            let data = tempData as! [CrewModel]
            cell.configureCrewCell(item: data[indexPath.item])
        case dataKeys[2]:
            let data = tempData as! RecommendModel
            cell.configureRecommendCell(item: data.results[indexPath.item])
        default:
            print("error")
        }
        
        return cell
    }
    
}


    
