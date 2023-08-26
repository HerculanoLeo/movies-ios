//
//  FormControl.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation

class FormControl {
  private(set) var fields: [FormField] = []

  func add(_ field: FormField) {
    self.fields.append(field)
  }

  func addAll(_ fields: [FormField]) {
    for field in fields {
      self.add(field)
    }
  }

  func setErrors(_ errors: [FormFieldError]) {
    for field in fields {
      field.setActiveErrors(errors)
    }
  }

  func cleanErrors() {
    for field in fields {
      field.cleanErrors()
    }
  }
}
