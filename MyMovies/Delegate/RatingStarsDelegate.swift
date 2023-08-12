//
//  RatingStarsDelegate.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 12/08/23.
//

import Foundation
import RxSwift

@objc protocol RatingStarsDelegate {
  var markedStars: Int { get }
  var readOnly: Bool { get }
  @objc optional func onChangeValue(_ stars: Int) -> Void
}
