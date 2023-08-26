//
//  FormField.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation

protocol FormField {
  var name: String { get }
  var errors: [ErrorSchema] { get }
  var activeErrors: [FormFieldError] { get }

  func setActiveErrors(_ errors: [FormFieldError])
  func cleanErrors()
}

struct ErrorSchema {
  var error: FormFieldError
  var message: String
}

protocol FormFieldError: Swift.Error {
  var fieldName: String { get }
}

extension FormFieldError {
  var fieldName: String {
    get {
      return String(describing: self)
    }
  }
}
