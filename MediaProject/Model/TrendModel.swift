//
//  TrendModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import Foundation

struct TrendModel: Decodable {
    let results: [TrendTV]
}

struct TrendTV: Decodable {
    let id: Int
    let posterPath: String
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case name
    }
}
