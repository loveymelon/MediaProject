//
//  ConfigureUI.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import Foundation

@objc protocol ConfigureUIProtocol {
    func configureUI()
    func configureHierarchy()
    func configureLayout()
    @objc optional func configureView()
}
