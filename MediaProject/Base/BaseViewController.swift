//
//  BaseViewController.swift
//  MediaProject
//
//  Created by 김진수 on 1/31/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    let group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .black
        
        configureView()
        networkingData()
    }
    
    func configureView() {
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func networkingData() {
        
    }

}

