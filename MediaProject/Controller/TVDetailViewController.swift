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
    
    let backImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()
    
    let episodesNumber: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    let seasonNumber: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    let castLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    let crewLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        return label
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: MovieTableViewCell.collectionFlowLayout())
    
    var id: Int?
    var castName = ""
    var recommendData: [RecommendTV] = []{
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        group.enter()
        TMDBAPIManager.shared.fetchDetail(id: id!) { result in
            let url = URL(string: "https://image.tmdb.org/t/p/w500\(result.backdropPath!)")
            self.backImageView.kf.setImage(with: url!)
            self.nameLabel.text = result.name
            self.episodesNumber.text = "에피소드 \(result.numberOfEpisodes)화"
            self.seasonNumber.text = "시즌 수 \(result.numberOfSeasons)"
            self.overviewLabel.text = result.overview
            self.group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchCredits(id: id!) { result in
            for index in 0...1 {
                self.castName += result.cast[index].name
            }
            self.crewLabel.text = "스탭: \(result.crew[0].name)"
            self.group.leave()
        }
        
        group.enter()
        TMDBAPIManager.shared.fetchRecommend(id: id!) { result in
            self.recommendData = result
            self.group.leave()
        }
        
        group.notify(queue: .main) {
            self.castLabel.text = "배우: \(self.castName)"
        }
    }
    
    override func configureHierarchy() {
        self.view.addSubview(backImageView)
        self.view.addSubview(nameLabel)
        self.view.addSubview(episodesNumber)
        self.view.addSubview(seasonNumber)
        self.view.addSubview(overviewLabel)
        self.view.addSubview(castLabel)
        self.view.addSubview(crewLabel)
        self.view.addSubview(collectionView)
    }
    
    override func configureLayout() {
        self.backImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(self.backImageView.snp.width).multipliedBy(0.5)
        }
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.backImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(40)
        }
        self.episodesNumber.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.height.equalTo(22)
        }
        self.seasonNumber.snp.makeConstraints { make in
            make.top.equalTo(self.episodesNumber.snp.top)
            make.leading.equalTo(self.episodesNumber.snp.trailing).offset(5)
            make.height.equalTo(22)
        }
        self.overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(self.episodesNumber.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(70)
        }
        
        self.castLabel.snp.makeConstraints { make in
            make.top.equalTo(self.overviewLabel.snp.bottom).inset(5)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(22)
        }
        
        self.crewLabel.snp.makeConstraints { make in
            make.top.equalTo(self.castLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading).inset(10)
            make.height.equalTo(22)
        }
        
        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.castLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    override func configureView() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .white
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: Helper.movieCollectionCellIdentifier)
        self.collectionView.backgroundColor = .black
    }
}

extension TVDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Helper.movieCollectionCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        
        let data = recommendData[indexPath.item]
        let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath)")
        
        print()
        cell.mainImageView.kf.setImage(with: url)
        cell.imageLabel.text = data.name
        
        return cell
    }
    
}


