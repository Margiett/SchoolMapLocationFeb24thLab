//
//  SchoolModel.swift
//  SchoolMapLocationFeb24thLab
//
//  Created by Margiett Gil on 2/24/20.
//  Copyright © 2020 Margiett Gil. All rights reserved.
//

import Foundation


struct NYCPublicSchool: Codable {
    let schools: [School]
}

struct School: Codable {
    let schoolName: String
    let location: String
    let latitude: String
    let longitude: String
//MARK: not allowing me to add codng keys
    private enum CodingKeys: String, Codable, CodingKey {
        case schoolName = "school_name"
        case location
        case latitude
        case longitude
    }
}

