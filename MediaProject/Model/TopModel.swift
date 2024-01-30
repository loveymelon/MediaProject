//
//  TopModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import Foundation

struct TopModel: Decodable {
    let results: [TopRates]
}

struct TopRates: Decodable {
    let title: String
    let posterPath: String?
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case id
    }
}
