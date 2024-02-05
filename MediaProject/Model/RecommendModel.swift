//
//  RecommendModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/31/24.
//

import Foundation

struct RecommendModel: Decodable {
    let page: Int
    let total_pages: Int
    let total_results: Int
    let results: [RecommendTV]
}

struct RecommendTV: Decodable {
    let posterPath: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case name
    }
}
