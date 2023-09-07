//
//  Movie.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import UIKit

struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let poster_path: String
    let release_date: String
    let vote_average: Double
    let poster_image_path: String?
    
    var posterImage: UIImage? {
        guard let path = poster_image_path, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return UIImage(data: data)
    }
}
