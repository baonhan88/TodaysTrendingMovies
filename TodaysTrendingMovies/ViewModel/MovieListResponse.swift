//
//  MovieListResponse.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

struct MovieListResponse: Decodable {
    let results: [Movie]
    let page: Int
}
