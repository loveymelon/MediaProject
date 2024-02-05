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
    case detail(id: Int, movie: Bool)
    case credit(id: Int, movie: Bool)
    case recommend(id: Int, movie: Bool)
    
    var endPoint: String {
        switch self {
        case .popular:
            return baseUrl + "discover/tv"
        case .trendingTV:
            return baseUrl + "trending/tv/week"
        case .topRate:
            return baseUrl + "discover/movie"
        case .detail(let id, let movie):
            return movie == false ? baseUrl + "tv/\(id)" : baseUrl + "movie/\(id)"
        case .credit(let id, let movie):
            return movie == false ? baseUrl + "tv/\(id)/aggregate_credits" : baseUrl + "movie/\(id)/credits"
        case .recommend(let id, let movie):
            return movie == false ? baseUrl + "tv/\(id)/recommendations" : baseUrl + "movie/\(id)/recommendations"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameter: Parameters {
        switch self {
        case .popular:
            ["language": "ko-KR"]
        case .trendingTV:
            ["language": "ko-KR"]
        case .topRate:
            ["language": "ko-KR"]
        case .detail:
            ["language": "ko-KR"]
        case .recommend:
            ["language": "ko-KR"]
        case .credit:
            ["language": "ko-KR"]
        }
    }
    
    var urlEncoding: URLEncoding {
        switch self {
        case .popular:
            URLEncoding(destination: .queryString)
        case .trendingTV:
            URLEncoding(destination: .queryString)
        case .topRate:
            URLEncoding(destination: .queryString)
        case .detail:
            URLEncoding(destination: .queryString)
        case .credit:
            URLEncoding(destination: .queryString)
        case .recommend:
            URLEncoding(destination: .queryString)
        }
    }
    
}

