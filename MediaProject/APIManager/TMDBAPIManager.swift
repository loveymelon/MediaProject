//
//  TMDBAPIManager.swift
//  MediaProject
//
//  Created by 김진수 on 1/30/24.
//

import Foundation
import Alamofire

struct TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    func fetchPopularMovie(completionHandler: @escaping ([PopularMovies]) -> Void) {
        let url = "https://api.themoviedb.org/3/discover/tv"
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.key
        ]
        
        AF.request(url, headers: header).validate(statusCode: 200..<300).responseDecodable(of: PopularModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchTrendingTV(completionHandler: @escaping ([TrendTV]) -> Void) {
        let url = "https://api.themoviedb.org/3/trending/tv/week"
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.key
        ]
        
        AF.request(url, headers: header).validate(statusCode: 200..<300).responseDecodable(of: TrendModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchTopRate(completionHandler: @escaping ([TopRates]) -> Void) {
        let url = "https://api.themoviedb.org/3/discover/movie"
        
        let header: HTTPHeaders = [
            "accept": "application/json",
            "Authorization": APIKey.key
        ]
        
        AF.request(url, headers: header).validate(statusCode: 200..<300).responseDecodable(of: TopModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
