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
    
    func fetchContents<T: Decodable>(type: T.Type, api: TMDBAPI, completionHandler: @escaping (T) -> Void) {
        
        AF.request(api.endPoint, method: api.method, parameters: api.parameter, encoding: api.urlEncoding, headers: api.header).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
