//
//  TVDetailModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/31/24.
//

import Foundation

struct TVDetailModel: Decodable {
    let backdropPath: String?
    let name: String
    let numberOfEpisodes: Int
    let numberOfSeasons: Int
    let overview: String
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case name
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case overview
    }
}
