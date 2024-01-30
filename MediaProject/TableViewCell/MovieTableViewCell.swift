//
//  PopularTableViewCell.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    let movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MovieTableViewCell: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        self.contentView.addSubview(categoryLabel)
        self.contentView.addSubview(movieCollectionView)
    }
    
    func configureLayout() {
        self.categoryLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(self.contentView.snp.top).inset(5)
            make.height.equalTo(22)
        }
        
        self.movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.categoryLabel.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureView() {
        self.backgroundColor = .black
        self.movieCollectionView.backgroundColor = .black
    }
}

extension MovieTableViewCell {
    static func collectionFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 5
//        flowLayout.minimumLineSpacing = 0
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 , height: UIScreen.main.bounds.height / 4)
        return flowLayout
    }
    
    func configureCell(data: String) {
        self.categoryLabel.text = data
    }
    
}
