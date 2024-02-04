//
//  DetailView.swift
//  MediaProject
//
//  Created by 김진수 on 2/4/24.
//

import UIKit
import SnapKit
import Then

class DetailView: UIView {
    
    let tableView = UITableView().then {
        $0.rowHeight = UIScreen.main.bounds.height / 3
        $0.register(MovieTableViewCell.self, forCellReuseIdentifier: Helper.movieTableCellIdentifier)
        $0.register(DetailTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: Helper.detailTableHeaderIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DetailView: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
    }
    
    func configureHierarchy() {
        self.addSubview(tableView)
    }
    
    func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
