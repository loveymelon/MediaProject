//
//  PopularModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import Foundation

struct ContentsModel: Decodable {
    let results: [Contents]
}

struct Contents: Decodable {
    let id: Int
    let name: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
    }
}
