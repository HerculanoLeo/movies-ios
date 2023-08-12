//
//  MovieDetailsDelegate.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import Foundation

protocol MovieDetailsDelegate: AnyObject {
  var movieSelectedId: String { get }
  func selectMovie(_ movie: Movie) -> Void
  func onMovieUpdate() -> Void
}
