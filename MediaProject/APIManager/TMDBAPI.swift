//
//  TMDBAPI.swift
//  MediaProject
//
//  Created by 김진수 on 2/1/24.
//

import Foundation
import Alamofire

enum TMDBAPI {
    
    var baseUrl: String {
        return "https://api.themoviedb.org/3/"
    }
    
    var header: HTTPHeaders {
        return ["accept": "application/json", "Authorization": APIKey.key]
    }
    
    case popular
    case trendingTV
    case topRate
    
    var endPoint: String {
        switch self {
        case .popular:
            return baseUrl + "discover/tv"
        case .trendingTV:
            return baseUrl + "trending/tv/week"
        case .topRate:
            return baseUrl + "discover/movie"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
}

