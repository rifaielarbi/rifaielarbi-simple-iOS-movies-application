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
    // Error handling
    @Published var errorMessage: String?

    init() {
        fetchTrendingMovies()
    }

    // Fetch trending movies
    func fetchTrendingMovies() {
        NetworkLayer.shared.getTrendingMovies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.movies = response.results
                    self?.onMoviesFetched?() // Notify ViewController
                case .failure(let error):
                    self?.onError?(error.localizedDescription) // Notify ViewController of error
                }
            }
        }
    }

    // Fetch movie details for a specific movie ID
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
