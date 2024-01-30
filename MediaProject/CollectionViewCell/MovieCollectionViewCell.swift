//
//  PopularCollectionViewCell.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import UIKit
import SnapKit

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
    
}
