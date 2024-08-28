//
//  HomeViewController.swift
//  Movies
//
//  Created by Arabi's Mac on 26/8/2024.
//

import UIKit

class HomeViewController: UIViewController {
    private let homeFeedTable: UITableView = {
        let table = UITableView()
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search Movies"
        return searchController
    }()

    private let viewModel = MoviesViewModel() 

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)

        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        title = "Movies"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 34)]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // Fetch movies
        viewModel.onMoviesFetched = { [weak self] in
            self?.homeFeedTable.reloadData()
        }

        viewModel.onError = { [weak self] error in
            self?.showErrorAlert(message: error)
        }

        viewModel.fetchTrendingMovies()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        let movieDetailsVC = MovieDetailsViewController()
        movieDetailsVC.movieId = selectedMovie.id
        navigationController?.pushViewController(movieDetailsVC, animated: false)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        let movie = viewModel.movies[indexPath.row]
        cell.configure(with: movie)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
