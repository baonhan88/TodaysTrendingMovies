//
//  MovieRealmManager.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/06.
//

import Foundation
import RealmSwift
import Kingfisher

class MovieRealmManager: ObservableObject {
    @Published var movieList = [Movie]()
    @Published var searchMovieList = [Movie]()
    @Published var movieDetail = MovieDetail.init(id: 0, title: "", poster_path: "", backdrop_path: "", release_date: "", vote_average: 0, overview: "", backdrop_image_path: "")
    
    private var realm: Realm

    init() {
        realm = try! Realm()
    }

    func saveMoviesToRealm() {
        try! realm.write {
            for movie in movieList {
                guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") else { return }

                let resource = KF.ImageResource(downloadURL: url)
                KingfisherManager.shared.retrieveImage(with: resource) { result in
                    switch result {
                    case .success(let image):
                        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        let documentsDirectory = paths[0]
                        let filePath = "\(documentsDirectory)/\(movie.id)_poster.png"
                        let url = URL(fileURLWithPath: filePath)

                        if let data = image.data() {
                            try? data.write(to: url)

                            let movieRealm = MovieRealm()
                            movieRealm.id = movie.id
                            movieRealm.title = movie.title
                            movieRealm.poster_path = movie.poster_path
                            movieRealm.release_date = movie.release_date
                            movieRealm.vote_average = movie.vote_average
                            movieRealm.poster_image_path = filePath
                            
                            do {
                                try self.realm.safeWrite {
                                    self.realm.add(movieRealm, update: .modified)
                                }
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }

    func getMoviesFromRealm() {
        let movieRealms = realm.objects(MovieRealm.self)
        movieList = movieRealms.map { Movie(id: $0.id, title: $0.title, poster_path: $0.poster_path, release_date: $0.release_date, vote_average: $0.vote_average, poster_image_path: $0.poster_image_path) }
    }
    
    func saveMovieDetailToRealm(movieDetail: MovieDetail) {
        if realm.object(ofType: MovieDetailRealm.self, forPrimaryKey: movieDetail.id) != nil {
            return
        }
        
        try! realm.write {
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(movieDetail.backdrop_path)") else { return }

            let resource = KF.ImageResource(downloadURL: url)
            KingfisherManager.shared.retrieveImage(with: resource) { result in
                switch result {
                case .success(let image):
                    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                    let documentsDirectory = paths[0]
                    let filePath = "\(documentsDirectory)/\(movieDetail.id)_backdrop.png"
                    let url = URL(fileURLWithPath: filePath)

                    if let data = image.data() {
                        try? data.write(to: url)

                        let movieDetailRealm = MovieDetailRealm()
                        movieDetailRealm.id = movieDetail.id
                        movieDetailRealm.title = movieDetail.title
                        movieDetailRealm.poster_path = movieDetail.poster_path
                        movieDetailRealm.backdrop_path = movieDetail.backdrop_path
                        movieDetailRealm.release_date = movieDetail.release_date
                        movieDetailRealm.vote_average = movieDetail.vote_average
                        movieDetailRealm.overview = movieDetail.overview
                        movieDetailRealm.backdrop_image_path = filePath
                        
                        do {
                            try self.realm.safeWrite {
                                self.realm.add(movieDetailRealm, update: .modified)
                            }
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getMovieDetailFromRealm(id: Int) -> MovieDetail? {
        if let movieDetailRealm = realm.object(ofType: MovieDetailRealm.self, forPrimaryKey: id) {
            return MovieDetail.init(id: movieDetailRealm.id, title: movieDetailRealm.title, poster_path: movieDetailRealm.poster_path, backdrop_path: movieDetailRealm.backdrop_path, release_date: movieDetailRealm.release_date, vote_average: movieDetailRealm.vote_average, overview: movieDetailRealm.overview, backdrop_image_path: movieDetailRealm.backdrop_image_path)
        }
        
        return nil
    }
    
    func searchMovieFromRealm(query: String) {
        let movieRealms = realm.objects(MovieRealm.self).filter("title CONTAINS[c] %@", query)
        searchMovieList = movieRealms.map { Movie(id: $0.id, title: $0.title, poster_path: $0.poster_path, release_date: $0.release_date, vote_average: $0.vote_average, poster_image_path: $0.poster_image_path) }
   }
}

extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
