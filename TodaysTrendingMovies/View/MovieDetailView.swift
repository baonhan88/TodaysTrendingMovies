//
//  MovieDetailView.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import Foundation
import SwiftUI

struct MovieDetailView: View {
    @State private var movieDetail: MovieDetail?
    
    @StateObject var networkStatus = NetworkStatus()

    let movieID: Int

    var body: some View {
        if networkStatus.isConnected {
            Group {
                if let movieDetail = movieDetail {
                    ScrollView {
                       VStack(alignment: .center) {
                           if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movieDetail.backdrop_path)") {
                               AsyncImage(url: url) { image in
                                   image.resizable()
                                       .aspectRatio(contentMode: .fit)
                               }
                               placeholder: {
                                   ProgressView()
                               }
                               .frame(height: 200)
                               .cornerRadius(10)
                               .clipped()
                           }
                           Text(movieDetail.title)
                               .font(.largeTitle)
                               .padding(.horizontal)
                           Spacer()
                           Text("Release Date: \(movieDetail.release_date)")
                               .font(.subheadline)
                           Text("Vote Average: \(movieDetail.vote_average, specifier: "%.1f")")
                               .font(.subheadline)
                           Spacer()
                           Text(movieDetail.overview)
                               .font(.body)
                               .padding(.horizontal)
                       }
                       .padding()
                   }
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                fetchMovieDetail()
            }
        } else {
            if let movieDetail = MovieRealmManager().getMovieDetailFromRealm(id: movieID) {
                ScrollView {
                    VStack(alignment: .center) {
                        if let image = movieDetail.backdropImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 200)
                                .cornerRadius(10)
                                .clipped()
                        }
                        Text(movieDetail.title)
                            .font(.largeTitle)
                            .padding(.horizontal)
                        Spacer()
                        Text("Release Date: \(movieDetail.release_date)")
                            .font(.subheadline)
                        Text("Vote Average: \(movieDetail.vote_average, specifier: "%.1f")")
                            .font(.subheadline)
                        Spacer()
                        Text(movieDetail.overview)
                            .font(.body)
                            .padding(.horizontal)
                    }
                    .padding()
                }
            }
        }
        
    }

    private func fetchMovieDetail() {
        MovieDetailViewModel.shared.fetchMovieDetail(id: movieID) { movieDetail in
            self.movieDetail = movieDetail
            
            // save movieDetail to Realm
            DispatchQueue.main.async {
                MovieRealmManager().saveMovieDetailToRealm(movieDetail: movieDetail)
            }
        }
    }
}
