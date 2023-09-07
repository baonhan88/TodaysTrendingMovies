//
//  MovieRealm.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/06.
//

import Foundation
import RealmSwift

class MovieRealm: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var poster_path: String
    @Persisted var poster_image_path: String
    @Persisted var release_date: String
    @Persisted var vote_average: Double
}
