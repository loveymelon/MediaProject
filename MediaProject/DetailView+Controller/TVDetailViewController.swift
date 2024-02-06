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
    var movie: Bool = false // 영화인지 티비인지 여부에 따라 네트워크 통신, 레이아웃이 달라짐
    
//    var detailData: TVDetailModel = TVDetailModel(backdropPath: nil, name: nil, originalTitle: nil, numberOfEpisodes: nil, numberOfSeasons: nil, overview: "")
    var detaildata: TVDetailModel?
    var credit: CreditModel?
    var recommend: RecommendModel?
    
    let dataKeys = ["cast", "crew", "recommend"]
    let group = DispatchGroup()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie)
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: TVDetailModel.self, api: .detail(id: id!, movie: movie)) { [self] result in
            detaildata = result
            group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: CreditModel.self, api: .credit(id: id!, movie: movie)) { [self] result in
            credit = result
            group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchContents(type: RecommendModel.self, api: .recommend(id: id!, movie: movie)) { [self] result in
            recommend = result
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
        cell.configureCell(data: dataKeys[indexPath.row])
        cell.movieCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Helper.detailTableHeaderIdentifier) as! DetailTableViewHeaderView
        
        guard let data = detaildata else { return headerView }
        
        headerView.movie = self.movie
        headerView.configureHearder(item: data)
        print(#function)
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 3
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension TVDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let key = collectionView.layer.name else { return 0 }
        
        switch key {
        case dataKeys[0]:
            guard let castData = credit?.cast else { return 0 }
            return castData.count
        case dataKeys[1]:
            guard let crewData = credit?.crew else { return 0 }
            return crewData.count
        case dataKeys[2]:
            guard let recommendData = recommend else { return 0 }
            return recommendData.results.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        guard let key = collectionView.layer.name else { return cell }
        
        switch key {
        case dataKeys[0]:
            guard let cast = credit?.cast else { return cell }
            let castData = cast[indexPath.item]
            cell.configureCastCell(item: castData)
        case dataKeys[1]:
            guard let crew = credit?.crew else { return cell }
//            print(indexPath.item, crew.count)
            let crewData = crew[indexPath.item]
            cell.configureCrewCell(item: crewData)
        case dataKeys[2]:
            guard let recommend = recommend?.results else { return cell }
            let recommendData = recommend[indexPath.item]
            cell.configureRecommendCell(item: recommendData)
        default:
            print("error")
        }
        
        return cell
    }
    
}


    
