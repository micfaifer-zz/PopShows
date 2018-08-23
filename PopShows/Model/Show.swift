//
//  Show.swift
//
//  Created by lugia on 12/08/18.
//  Copyright © 2018 MicFaifer. All rights reserved.
//

import Foundation

struct Show: Codable {
    let originalName: String?
    let genreIDS: [Int]?
    let name: String?
    let popularity: Double?
    let originCountry: [String]?
    let voteCount: Int?
    let firstAirDate, backdropPath, originalLanguage: String?
    let id: Int?
    let voteAverage: Double?
    let overview, posterPath: String?
}

