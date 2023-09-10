//
//  InputRatingStarsViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 10/09/23.
//

import Foundation

struct InputRatingStarsViewModel {
  var name: String
  var label: String
  var value: Int?
  var defaultValue: Int?
  var requiered: Bool?
  var inputAttributes: InputAttributes = .init(heigth: 50)
  var errors: [ErrorSchema] = []
  var activeErrors: [FormFieldError] = []
}
