//
//  NetworkLayer.swift
//  Movies
//
//  Created by Arabi's Mac on 26/8/2024.
//

import Alamofire
import Foundation

class NetworkLayer {
    static let shared = NetworkLayer()
    
    private init() {}
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3" // Replace with your actual API key
    
    // MARK: - HTTP Methods
    
    func get<T: Decodable>(endpoint: String, parameters: Parameters? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var allParameters = parameters ?? [:]
        allParameters["api_key"] = apiKey
        
        let url = baseURL + endpoint
        print("Requesting URL: \(url)") // Debugging line
        print("Parameters: \(allParameters)") // Debugging line
        
        AF.request(url, method: .get, parameters: allParameters).responseDecodable(of: T.self) { response in
            print("Response: \(response)") // Debugging line
            switch response.result {
            case .success(let value):
                print("Success: \(value)") // Debugging line
                completion(.success(value))
            case .failure(let error):
                print("Error: \(error)") // Debugging line
                completion(.failure(error))
            }
        }
    }

    // MARK: - Services
    
    func getTrendingMovies(completion: @escaping (Result<TrendingMoviesResponse, Error>) -> Void) {
        get(endpoint: "/discover/movie", completion: completion)
    }
    
    func getMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        get(endpoint: "/movie/\(movieId)", completion: completion)
    }
}

// MARK: - Models

struct TrendingMoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

struct MovieDetails: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let runtime: Int?
    let genres: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}

struct Genre: Codable {
    let id: Int
    let name: String
}
