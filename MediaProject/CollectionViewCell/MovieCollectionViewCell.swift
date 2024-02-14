//
//  PopularCollectionViewCell.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import UIKit
import SnapKit
import Kingfisher
import Then

final class MovieCollectionViewCell: UICollectionViewCell {
    private let mainImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private let imageLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let noneLabel = UILabel().then {
        $0.textColor = .white
        $0.font = .boldSystemFont(ofSize: 20)
        $0.text = "데이터가 없습니다 ㅜ.ㅜ"
    }
    
    private let baseUrl = "https://image.tmdb.org/t/p/w500"
    var seError: SeSACError?
    
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
        if seError != nil {
            self.contentView.addSubview(noneLabel)
        } else {
            self.contentView.addSubview(mainImageView)
            self.mainImageView.addSubview(imageLabel)
        }
    }
    
    func configureLayout() {
        
        if seError != nil {
            self.noneLabel.snp.makeConstraints { make in
                make.height.equalTo(40)
                make.centerX.centerY.equalTo(self.contentView)
            }
        } else {
            self.mainImageView.snp.makeConstraints { make in
                make.horizontalEdges.verticalEdges.equalToSuperview()
            }
            self.imageLabel.snp.makeConstraints { make in
                make.height.equalTo(22)
                make.leading.bottom.equalTo(self.mainImageView).inset(5)
            }
        }
        
    }
    
    func configureView() {
        self.backgroundColor = .black
    }
    
}

extension MovieCollectionViewCell {
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
    
    func configureCreditCell(itemModel: CreditModel?, dataKey: String, index: Int) {
        
        guard let data = itemModel else {
            // 데이터가 없을때의 셀로 구성...
            return
        }
        
        if dataKey == "cast" {
            let item = data.cast[index]
            
            self.imageLabel.text = item.name
            
            switch item.profilePath {
            case .none:
                self.mainImageView.image = UIImage(systemName: "xmark")
            case .some(let imagePath):
                let url = URL(string: baseUrl + imagePath)
                self.mainImageView.kf.setImage(with: url)
            }
        } else {
            let item = data.crew[index]
            
            self.imageLabel.text = item.name
            
            switch item.profilePath {
            case .none:
                self.mainImageView.image = UIImage(systemName: "xmark")
            case .some(let imagePath):
                let url = URL(string: baseUrl + imagePath)
                self.mainImageView.kf.setImage(with: url)
            }
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
