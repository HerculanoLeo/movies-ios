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

  private let moviesPublish = BehaviorSubject<ObservableErrorWrapper<[Movie]>>(value: .success([]))

  var onChangeMovies: Observable<ObservableErrorWrapper<[Movie]>> {
    get {
      return moviesPublish.asObserver()
    }
  }

  var movies: [Movie] {
    get {
      do {
        let wrapper = try moviesPublish.value()
        switch wrapper {
        case .success(let values):
          return values ?? []
        case .error(_):
          return []
        }
      } catch {
        return []
      }

    }
  }

  func fetchMovies() {
    MovieAPI.findAll() {[weak self] result in
      switch result {
      case .success(let movies):
        self?.moviesPublish.onNext(.success(movies))
      case .failure(let error):
        self?.moviesPublish.onNext(.error(error))
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
