//
//  RecommendModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/31/24.
//

import Foundation

struct RecommendModel: Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [RecommendTV]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case results
    }
}

struct RecommendTV: Decodable {
    let posterPath: String?
    let name: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case name, title
    }
}
