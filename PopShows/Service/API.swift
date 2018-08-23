//
//  API.swift
//
//  Created by lugia on 12/08/18.
//  Copyright © 2018 MicFaifer. All rights reserved.
//

import Foundation

struct TheMovieDBAPI {
    static let key = "84c7d294dad40a96a206ce33f66f496c"
    static let urlBase = "https://api.themoviedb.org/3/tv/popular?" + "api_key=" + TheMovieDBAPI.key
    static let imagePath = "https://image.tmdb.org/t/p/w500"
}
