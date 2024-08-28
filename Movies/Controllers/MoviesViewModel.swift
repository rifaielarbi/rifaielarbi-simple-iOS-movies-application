//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Arabi's Mac on 27/8/2024.
//

import Foundation

class MoviesViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var movieDetails: MovieDetails?
    private(set) var movies: [Movie] = []
    var onMoviesFetched: (() -> Void)?
    var onError: ((String) -> Void)?
    @Published var errorMessage: String?

    init() {
        fetchTrendingMovies()
    }

    func fetchTrendingMovies() {
        NetworkLayer.shared.getTrendingMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.movies = response.results
                    self?.onMoviesFetched?() 
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }

    func fetchMovieDetails(movieId: Int) {
        NetworkLayer.shared.getMovieDetails(movieId: movieId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.movieDetails = details
                case .failure(let error):
                    self?.errorMessage = "Failed to fetch movie details: \(error.localizedDescription)"
                }
            }
        }
    }
}
