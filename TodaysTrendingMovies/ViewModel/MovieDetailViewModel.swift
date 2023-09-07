//
//  MovieDetailViewModel.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import Foundation

class MovieDetailViewModel {
    let apiKey = "47aa75b56464da7a186b813a50035cd4"
    
    static let shared = MovieDetailViewModel()
    private init() {}

    func fetchMovieDetail(id: Int, completion: @escaping (MovieDetail) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)")!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let d = data {
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: d)
                    completion(movieDetail)
                } else {
                    print("No Data")
                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}
