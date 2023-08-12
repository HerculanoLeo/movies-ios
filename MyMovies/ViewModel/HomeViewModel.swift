//
//  HomeViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import RxSwift

class HomeViewModel: MovieDetailsDelegate {
  var movieSelectedId: String = ""

  private let moviesPublish = BehaviorSubject<[Movie]>(value: [])

  var onChangeMovies: Observable<[Movie]> {
    get {
      return moviesPublish.asObserver()
    }
  }

  var movies: [Movie] {
    get {
      do {
        return try moviesPublish.value()
      } catch {
        return []
      }
    }
  }

  func fetchMovies() {
    MovieAPI.findAll() {[weak self] result in
      switch result {
      case .success(let movies):
        self?.moviesPublish.onNext(movies)
      case .failure(let error):
        self?.moviesPublish.onError(error)
      }
    }
  }

  func selectMovie(_ movie: Movie) {
    self.movieSelectedId = movie.id
  }

  func onMovieUpdate() {
    self.fetchMovies()
  }

}
