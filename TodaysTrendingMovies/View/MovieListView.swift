//
//  MovieListView.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import SwiftUI

struct MovieListView: View {
    @StateObject var networkStatus = NetworkStatus()
    
    @ObservedObject var movieListViewModel = MovieListViewModel()
    @ObservedObject var movieRealm = MovieRealmManager()
    
    @State private var query: String = ""

    var body: some View {
        NavigationView {
            if networkStatus.isConnected {
                VStack {
                    TextField("Search", text: $query, onCommit:  {
                        if !self.query.isEmpty {
                            self.movieListViewModel.search(query: self.query)
                        }
                    }).padding()
                    
                    if query == "" { // not searching, should show trending movies
                        List(movieListViewModel.movieList) { movie in
                            NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                                MovieRow(movie: movie)
                            }
                            .onAppear {
                                if self.movieListViewModel.movieList.isLast(movie) {
                                    self.movieListViewModel.fetch()
                                }
                            }
                        }
                        .onAppear {
                            self.movieListViewModel.fetch()
                        }
                    } else {
                        List(movieListViewModel.movieSearchingList) { movie in
                            NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                                MovieRow(movie: movie)
                            }
                            .onAppear {
                                if self.movieListViewModel.movieSearchingList.isLast(movie) {
                                    self.movieListViewModel.search(query: self.query)
                                }
                            }
                        }
                        .onAppear {
                            self.movieListViewModel.search(query: self.query)
                        }
                    }
                }
            } else {
                VStack {
                    TextField("Search", text: $query, onCommit:  {
                        if !self.query.isEmpty {
                            self.movieRealm.searchMovieFromRealm(query: self.query)
                        }
                    }).padding()
                    
                    if query == "" {
                        List(movieRealm.movieList) { movie in
                            NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                                MovieRow(movie: movie)
                            }
                        }
                        .onAppear {
                            self.movieRealm.getMoviesFromRealm()
                        }
                    } else {
                        List(movieRealm.searchMovieList) { movie in
                            NavigationLink(destination: MovieDetailView(movieID: movie.id)) {
                                MovieRow(movie: movie)
                            }
                        }
                        .onAppear {
                            self.movieRealm.searchMovieFromRealm(query: query)
                        }
                    }
                }
                
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}

extension Array where Element: Identifiable {
    func isLast(_ element: Element) -> Bool {
        guard let lastElement = last else {
            return false
        }
        return lastElement.id == element.id
    }
}
