//
//  AddMovieValidation.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation
import Peppermint

let addMovieConstraints = TypeConstraint<MovieRegisterRequest, MovieRegisterRequest.Error> {
  KeyPathConstraint(\.name) {
    PredicateConstraint(.length(min: 5), error: .name)
  }
  KeyPathConstraint(\.synopsys) {
    PredicateConstraint(.length(min: 5), error: .synopsys).optional()
  }
  KeyPathConstraint(\.ageGroup) {
    PredicateConstraint(.length(min: 5), error: .ageGroup)
  }
  KeyPathConstraint(\.stars) {
    PredicateConstraint(.range(min: 0, max: 5), error: .stars)
  }
  KeyPathConstraint(\.movieCoverUrl) {
    PredicateConstraint(.url, error: .movieCoverUrl).optional()
  }
  KeyPathConstraint(\.movieWallpaperUrl) {
    PredicateConstraint(.url, error: .movieWallpaperUrl).optional()
  }
}
