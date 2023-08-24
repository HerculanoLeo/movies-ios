//
//  ApiResponseWrapper.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 21/08/23.
//

import Foundation

enum ObservableErrorWrapper<T> {
  case success(T)
  case error(Error)
}
