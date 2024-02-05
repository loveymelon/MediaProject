//
//  DetailModels.swift
//  MediaProject
//
//  Created by 김진수 on 2/5/24.
//

import Foundation

enum DetailModels {
    case detail(data: TVDetailModel)
    case cast(data: [CastModel])
    case crew(data: [CrewModel])
    case recommend(data: RecommendModel)
    
    var count: Int {
        switch self {
        case .detail(let data):
            return 0
        case .cast(let data):
            return data.count
        case .crew(let data):
            return data.count
        case .recommend(let data):
            return data.results.count
        }
    }
    
    var data: Any {
        switch self {
        case .detail(let data):
            return data
        case .cast(let data):
            return data
        case .crew(let data):
            return data
        case .recommend(let data):
            return data
        }
    }
}
