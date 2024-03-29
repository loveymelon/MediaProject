//
//  MainView.swift
//  MediaProject
//
//  Created by 김진수 on 2/1/24.
//

import UIKit
import SnapKit
import Then

final class MainView: UIView {
    
    let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.sectionHeaderHeight = UITableView.automaticDimension
        $0.rowHeight = UIScreen.main.bounds.height / 3
        $0.register(MovieTableViewCell.self, forCellReuseIdentifier: Helper.movieTableCellIdentifier)
    }
    
    let titleArray = ["Popular", "Top Rate", "Trending"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView: ConfigureUIProtocol {
    func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {
        self.addSubview(tableView)
    }
    
    func configureLayout() {
        self.tableView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        self.backgroundColor = .black
        self.tableView.backgroundColor = .black
    }
}
