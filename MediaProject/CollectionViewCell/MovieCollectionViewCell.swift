//
//  PopularCollectionViewCell.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import UIKit
import SnapKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let imageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    let baseUrl = "https://image.tmdb.org/t/p/w500"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MovieCollectionViewCell: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        self.contentView.addSubview(mainImageView)
        self.mainImageView.addSubview(imageLabel)
    }
    
    func configureLayout() {
        self.mainImageView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        self.imageLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.bottom.equalTo(self.mainImageView).inset(5)
        }
    }
    
    func configureView() {
        self.backgroundColor = .black
    }
    
    func configureContentsCell(item: Contents) {
        self.imageLabel.text = item.name == nil ? item.title : item.name
        
        switch item.posterPath {
        case .none:
            self.mainImageView.image = UIImage(systemName: "xmark")
        case .some(let imagePath):
            let url = URL(string: baseUrl + imagePath)
            self.mainImageView.kf.setImage(with: url)
        }
        
    }
    
    func configureCastCell(item: CastModel) {
        self.imageLabel.text = item.name
        
        switch item.profilePath {
        case .none:
            self.mainImageView.image = UIImage(systemName: "xmark")
        case .some(let imagePath):
            let url = URL(string: baseUrl + imagePath)
            self.mainImageView.kf.setImage(with: url)
        }
    }
    
    func configureCrewCell(item: CrewModel) {
        self.imageLabel.text = item.name
        
        switch item.profilePath {
        case .none:
            self.mainImageView.image = UIImage(systemName: "xmark")
        case .some(let imagePath):
            let url = URL(string: baseUrl + imagePath)
            self.mainImageView.kf.setImage(with: url)
        }
    }
    
    func configureRecommendCell(item: RecommendTV) {
        self.imageLabel.text = item.name
        
        switch item.posterPath {
        case .none:
            self.mainImageView.image = UIImage(systemName: "xmark")
        case .some(let imagePath):
            let url = URL(string: baseUrl + imagePath)
            self.mainImageView.kf.setImage(with: url)
        }
    }
    
}
