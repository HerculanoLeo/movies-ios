//
//  InputViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 14/08/23.
//

import Foundation
import UIKit

struct InputViewModel {
  var label: String
  var requiered: Bool?
  var inputAttributes: InputAttributes = .init()
}

struct InputAttributes {
  var heigth: CGFloat = 60
  var contentVerticalAlignment: UIControl.ContentVerticalAlignment = .center
}
