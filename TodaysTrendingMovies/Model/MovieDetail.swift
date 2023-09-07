//
//  MovieDetail.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import Foundation
import UIKit

struct MovieDetail: Identifiable, Decodable {
    var id: Int
    var title: String
    var poster_path: String
    var backdrop_path: String
    var release_date: String
    var vote_average: Double
    var overview: String
    var backdrop_image_path: String?
    
    var backdropImage: UIImage? {
        guard let path = backdrop_image_path, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        return UIImage(data: data)
    }
}
