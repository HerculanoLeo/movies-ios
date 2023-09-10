//
//  FormFieldBuilder.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 10/09/23.
//

import Foundation
import UIKit

protocol FormFieldBuilder {
  func build() -> FormField
}

struct TextFieldBuilder: FormFieldBuilder {
  let name: String
  let label: String
  let defaultValue: String?
  let requiered: Bool?
  let errors: [ErrorSchema]?
  let delegate: UITextFieldDelegate

  func build() -> FormField {
    let textFiel = UIInputTextView(.init(
      name: name,
      label: label,
      defaultValue: defaultValue,
      requiered: requiered,
      errors: errors ?? []
    ))
    textFiel.setTextFieldDelegate(delegate)
    return textFiel
  }
}

struct TextAreaBuilder: FormFieldBuilder {
  let name: String
  let label: String
  let defaultValue: String?
  let requiered: Bool?
  let errors: [ErrorSchema]?
  let delegate: UITextViewDelegate

  func build() -> FormField {
    let textArea = UIInputTextAreaView(.init(
      name: name,
      label: label,
      defaultValue: defaultValue,
      requiered: requiered,
      errors: errors ?? []
    ))
    textArea.setTextViewDelegate(delegate)
    return textArea
  }
}

struct DropdownBuilder<T>: FormFieldBuilder {
  let name: String
  let label: String
  let options: [Option<T>]?
  let selectedOption: Option<T>?
  let defaultOption: Option<T>?
  let requiered: Bool?
  let errors: [ErrorSchema]?
  let delegate: InputDropdownDelegate

  func build() -> FormField {
    let dropdown = UIInputDropdownView<T>(.init(
      name: name,
      label: label,
      options: options ?? [],
      selectedOption: selectedOption,
      defaultOption: defaultOption,
      requiered: requiered,
      errors: errors ?? [],
      delegate: delegate
    ))
    return dropdown
  }
}

struct RatingStarsViewBuilder: FormFieldBuilder {
  let name: String
  let label: String
  let defaultValue: Int?
  let requiered: Bool?
  let errors: [ErrorSchema]?

  func build() -> FormField {
    let ratingStarsView = UIInputRatingStarsView(.init(
      name: name,
      label: label,
      defaultValue: defaultValue,
      requiered: requiered,
      errors: errors ?? []
    ))
    return ratingStarsView
  }
}
