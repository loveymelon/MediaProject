//
//  DetailTableViewHeaderView.swift
//  MediaProject
//
//  Created by 김진수 on 2/4/24.
//

import UIKit
import SnapKit
import Kingfisher
import Then

class DetailTableViewHeaderView: UITableViewHeaderFooterView {
    
    let backImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    let nameLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
        $0.numberOfLines = 2
    }
    
    let episodesNumber = UILabel().then {
        $0.textColor = .lightGray
    }
    
    let seasonNumber = UILabel().then {
        $0.textColor = .lightGray
    }
    
    let overviewLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 15)
    }
    
    let baseUrl = "https://image.tmdb.org/t/p/w500"
    var movie: Bool = false {
        didSet {
            configureUI()
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
        
        self.contentView.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailTableViewHeaderView: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        contentView.addSubview(backImageView)
        contentView.addSubview(nameLabel)
        if movie == false {
            contentView.addSubview(episodesNumber)
            contentView.addSubview(seasonNumber)
        }
        contentView.addSubview(overviewLabel)
    }
    
    func configureLayout() {
        self.backImageView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.contentView.snp.horizontalEdges)
            make.top.equalTo(self.contentView.snp.top)
            make.height.equalTo(self.backImageView.snp.width).multipliedBy(0.5)
        }
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.backImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self.contentView.snp.horizontalEdges).inset(10)
            make.height.equalTo(40)
        }
        if movie == false {
            self.episodesNumber.snp.makeConstraints { make in
                make.top.equalTo(self.nameLabel.snp.bottom).offset(10)
                make.leading.equalTo(self.contentView.snp.leading).inset(10)
                make.height.equalTo(22)
            }
            self.seasonNumber.snp.makeConstraints { make in
                make.top.equalTo(self.episodesNumber.snp.top)
                make.leading.equalTo(self.episodesNumber.snp.trailing).offset(5)
                make.height.equalTo(22)
            }
            self.overviewLabel.snp.makeConstraints { make in
                make.top.equalTo(self.episodesNumber.snp.bottom)
                make.horizontalEdges.equalTo(self.contentView).inset(10)
                make.bottom.equalToSuperview()
            }
        } else {
            self.overviewLabel.snp.makeConstraints { make in
                make.top.equalTo(self.nameLabel.snp.bottom)
                make.horizontalEdges.equalTo(self.contentView).inset(10)
                make.bottom.equalToSuperview()
            }
        }
    }
    
    
}

extension DetailTableViewHeaderView {
    func configureHearder(item: TVDetailModel) {
        
        self.nameLabel.text = movie == false ? item.name : item.originalTitle
        if movie == false {
            self.episodesNumber.text = "에피소드 \(item.numberOfEpisodes)화"
            self.seasonNumber.text = "시즌 \(item.numberOfSeasons)"
        }
        self.overviewLabel.text = item.overview
        print(item.overview)
        
        switch item.backdropPath {
        case .none:
            self.backImageView.image = UIImage(systemName: "xmark")
        case .some(let imageUrl):
            let url = URL(string: baseUrl + imageUrl)
            self.backImageView.kf.setImage(with: url)
        }
        
    }
}
