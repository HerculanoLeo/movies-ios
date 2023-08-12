//
//  HomeViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import RxSwift

class HomeViewModel {
  private let moviesPublish = BehaviorSubject<[Movie]>(value: [])

  var moviesObservable: Observable<[Movie]> {
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
    MovieNetworking.findAll() {[weak self] result in
      switch result {
      case .success(let movies):
        print(movies)
        self?.moviesPublish.onNext(movies)
      case .failure(let error):
        self?.moviesPublish.onError(error)
      }
    }
  }

}
