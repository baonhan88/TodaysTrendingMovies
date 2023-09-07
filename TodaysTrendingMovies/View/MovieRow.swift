//
//  MovieRow.swift
//  TodaysTrendingMovies
//
//  Created by Nhan Bao on 2023/09/05.
//

import Foundation
import SwiftUI

struct MovieRow: View {
    let movie: Movie
    
    @StateObject var networkStatus = NetworkStatus()
    
    var body: some View {
        HStack {
            if networkStatus.isConnected {
                if let url = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 150)
                .cornerRadius(10)
                .clipped()
                }
            } else {
                if let image = movie.posterImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 150)
                        .cornerRadius(10)
                        .clipped()
                }
            }
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text("Year: \(String(movie.release_date.prefix(4)))")
                    .font(.subheadline)
                Text("Vote Average: \(movie.vote_average, specifier: "%.1f")")
                    .font(.subheadline)
            }
        }
    }
}
