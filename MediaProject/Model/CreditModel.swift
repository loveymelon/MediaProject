//
//  CreditModel.swift
//  MediaProject
//
//  Created by 김진수 on 1/31/24.
//

import Foundation

struct CreditModel: Decodable {
    let cast: [CastModel]
    let crew: [CrewModel]
}

struct CastModel: Decodable {
    var name: String
}

struct CrewModel: Decodable {
    var name: String
}
