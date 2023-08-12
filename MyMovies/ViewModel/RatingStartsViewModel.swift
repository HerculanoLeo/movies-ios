//
//  RatingStartsViewModel.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import Foundation
import RxSwift

class RatingStarsViewModel {
  private let starsSubject = PublishSubject<Int>()
  var onChangeValue: Observable<Int> {
    get {
      return self.starsSubject.asObserver()
    }
  }

  func changeValue(_ stars: Int) {
    self.starsSubject.onNext(validateStars(stars))
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
