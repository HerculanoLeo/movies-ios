//
//  InputViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 14/08/23.
//

import Foundation
import UIKit

struct InputViewModel {
  var name: String
  var label: String
  var requiered: Bool?
  var inputAttributes: InputAttributes = .init()
  var errors: [ErrorSchema] = []
  var activeErrors: [FormFieldError] = []
}

struct InputAttributes {
  var heigth: CGFloat = 60
  var contentVerticalAlignment: UIControl.ContentVerticalAlignment = .center
}
