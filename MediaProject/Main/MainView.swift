//
//  MainView.swift
//  MediaProject
//
//  Created by 김진수 on 2/1/24.
//

import UIKit
import SnapKit

class MainView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UIScreen.main.bounds.height / 3
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: Helper.movieTableCellIdentifier)
        return tableView
    }()
    
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
