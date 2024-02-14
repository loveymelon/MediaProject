//
//  TMDBSessionAPIManager.swift
//  MediaProject
//
//  Created by 김진수 on 2/6/24.
//

import Foundation

enum SeSACError: Error {
    case failedRequest
    case noData
    case invalidUrl
    case invalidResponse
    case invalidData
}

struct TMDBSessionAPIManager {
    
    static let shared = TMDBSessionAPIManager()
    
    typealias CompletionHandler<T: Decodable> = (T?, SeSACError?) -> Void
    
    private init() { }
    
    func fetchContetns<T: Decodable>(type: T.Type, api: TMDBAPI, completionHandler: @escaping CompletionHandler<T>) {
        
        var urlRequest = URLRequest(url: URL(string: api.endPoint)!)
        
        urlRequest.httpMethod = "GET"
//        urlRequest.headers = api.header
        urlRequest.addValue(APIKey.key, forHTTPHeaderField: "Authorization")
        print(urlRequest)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                print(error)
                completionHandler(nil, .failedRequest)
                return
            }
            
            guard let data = data else {
                print("a")
                completionHandler(nil, .invalidData)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("b")
                completionHandler(nil, .invalidResponse)
                return
            }
            
            guard response.statusCode == 200 else {
                print("error")
                completionHandler(nil, .failedRequest)
                return
            }
            print(#function)
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionHandler(result, nil)
                
                
            } catch {
                print(error)
                
                completionHandler(nil, .invalidData)
                
            }
        
        }.resume()
        
    }
    
}
