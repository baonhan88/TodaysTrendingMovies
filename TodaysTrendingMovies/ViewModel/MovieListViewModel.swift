//
//  MovieListViewModel.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import Foundation

class MovieListViewModel: ObservableObject {
    let apiKey = "47aa75b56464da7a186b813a50035cd4"
    
    @Published var movieList = [Movie]()
    @Published var movieSearchingList = [Movie]()
    var currentPage = 1
    
    var searchKeywords = ""
    var searchCurrentPage = 1
    
    func fetch() {
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)&page=\(currentPage)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let d = data {
                    let decodedLists = try JSONDecoder().decode(MovieListResponse.self, from: d)
                    DispatchQueue.main.async {
                        self.movieList.append(contentsOf: decodedLists.results)
                        
                        let movieRealmManager = MovieRealmManager()
                        movieRealmManager.movieList = decodedLists.results
                        movieRealmManager.saveMoviesToRealm()
                        
                        self.currentPage += 1
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
    
    func search(query: String) {
        if searchKeywords != query {
            searchCurrentPage = 1
            searchKeywords = query
            movieSearchingList = []
        }
        
        guard let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)&page=\(searchCurrentPage)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let decodedLists = try JSONDecoder().decode(MovieListResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.movieSearchingList.append(contentsOf: decodedLists.results)
                        
                        let movieRealmManager = MovieRealmManager()
                        movieRealmManager.movieList = decodedLists.results
                        movieRealmManager.saveMoviesToRealm()
                        
                        self.searchCurrentPage += 1
                    }
                } else {
                    print("No Data")
                }
            } catch {
                print("Error: \(error)")
            }
        }.resume()
    }
}
