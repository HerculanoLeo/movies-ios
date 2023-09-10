//
//  FormControl.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation
import UIKit
import Peppermint

class FormControl<T: Codable, E: FormFieldError> {
  private let jsonDecoder = JSONDecoder()
  private(set) var fields: [FormField] = []
  private(set) var formConstraints: TypeConstraint<T, E>?

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
    if let index = fields.firstIndex(where: { field in !field.activeErrors.isEmpty }) {
      print(index)
      fields[index].focus()
    }
  }

  func cleanErrors() {
    for field in fields {
      field.cleanErrors()
    }
  }

  func setFormContraints(_ constraints: TypeConstraint<T, E>) {
    self.formConstraints = constraints
  }

  func submit() -> Result<T, FormError> {
    cleanErrors()
    do {
      let value = try jsonDecoder.decode(T.self, from: getFormData())

      if let formConstraints = formConstraints {
        let result = formConstraints.evaluate(with: value)

        if case .failure(let summary) = result {
          setErrors(summary.errors)
          return .failure(FormError(message: "Falha ao submeter os dados"))
        }
      }
      return .success(value)
    } catch {
      print(error)
      return .failure(FormError(message: "Falha ao submeter os dados"))
    }
  }

  private func getFormData() throws -> Data {
    let dictionary = fields.reduce(into: [String: Any?].init()) { result, field in
      result[field.name] = field.value
    }
    return try JSONSerialization.data(withJSONObject: dictionary)
  }
}
