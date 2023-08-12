//
//  MovieDetailsViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import Foundation
import RxSwift

class MovieDetailsViewModel {
  private(set) var movie: Movie?

  private let moviePublish = PublishSubject<Movie>()

  var onMovieChange: Observable<Movie> {
    get {
      return moviePublish.asObserver()
    }
  }

  func fetchMovie(movieId: String) {
    MovieAPI.findById(id: movieId) {[weak self] result in
      switch result {
      case .success(let movie):
        self?.movie = movie
        self?.moviePublish.onNext(movie)
      case .failure(let error):
        self?.movie = nil
        self?.moviePublish.onError(error)
      }
    }
  }

}
