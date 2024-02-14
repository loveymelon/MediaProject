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
    
    typealias CompletionHandler<T: Decodable> = (T?, SeSACError?) -> Void
    
    private init() { }
    
    func fetchContents<T: Decodable>(type: T.Type, api: TMDBAPI, completionHandler: @escaping CompletionHandler<T>) {
        AF.request(api.endPoint, method: api.method, parameters: api.parameter, encoding: api.urlEncoding, headers: api.header).validate(statusCode: 200..<300).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let success):
                completionHandler(success, nil)
            case .failure(let failure):
                completionHandler(nil, .invalidData)
            }
        }
    }
}
