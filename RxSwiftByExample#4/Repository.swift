//
//  Repository.swift
//  RxSwiftByExample#4
//
//  Created by ParkSunJae on 2017. 4. 3..
//  Copyright © 2017년 Heaven. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier: Int!
    var language: String!
    var url: String!
    var name: String!
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["language"]
        url <- map["url"]
        name <- map["name"]
    }
}
