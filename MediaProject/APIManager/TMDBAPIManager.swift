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
    
    let baseUrl = "https://api.themoviedb.org/3/"
    
    let header: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": APIKey.key
    ]
    
    func fetchContents(api: TMDBAPI, completionHandler: @escaping (ContentsModel) -> Void) {
        
        AF.request(api.endPoint, method: api.method, headers: api.header).validate(statusCode: 200..<300).responseDecodable(of: ContentsModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchTopRate(api: TMDBAPI, completionHandler: @escaping ([TopRates]) -> Void) {
        
        AF.request(api.endPoint, method: api.method, headers: api.header).validate(statusCode: 200..<300).responseDecodable(of: TopModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchDetail(id: Int, completionHandler: @escaping (TVDetailModel) -> Void) {
        let url = "tv/\(id)"
        
        AF.request(baseUrl + url, headers: header).validate(statusCode: 200..<300).responseDecodable(of: TVDetailModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchRecommend(id: Int, completionHandler: @escaping ([RecommendTV]) -> Void) {
        let url = "tv/\(id)/recommendations"
        
        AF.request(baseUrl + url, headers: header).validate(statusCode: 200..<300).responseDecodable(of: RecommendModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success.results)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func fetchCredits(id: Int, completionHandler: @escaping (CreditModel) -> Void) {
        let url = "tv/\(id)/aggregate_credits"
        
        AF.request(baseUrl + url, headers: header).validate(statusCode: 200..<300).responseDecodable(of: CreditModel.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
