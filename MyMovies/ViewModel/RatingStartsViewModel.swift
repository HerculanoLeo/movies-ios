//
//  RatingStartsViewModel.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import Foundation

class RatingStarsViewModel {
  private var stars: Int
  var readOnly: Bool = true

  var markedStars: Int {
    get {
      return stars
    }
    set {
      stars = validateStars(newValue)
    }
  }

  init(stars: Int, readOnly: Bool = true) {
    self.stars = validateStars(stars)
    self.readOnly = readOnly
  }
}

private func validateStars(_ starts: Int) -> Int {
  if starts > 5 {
    return 5
  } else if starts < 0 {
    return 0
  } else {
    return starts
  }
}
