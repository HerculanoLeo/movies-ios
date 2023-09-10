//
//  InputViewModel.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 14/08/23.
//

import Foundation
import UIKit
import RxSwift

struct InputViewModel {
  var name: String
  var label: String
  var defaultValue: String?
  var requiered: Bool?
  var inputAttributes: InputAttributes = .init()
  var errors: [ErrorSchema] = []
  var activeErrors: [FormFieldError] = []
}

struct InputAttributes {
  var heigth: CGFloat = 60
  var contentVerticalAlignment: UIControl.ContentVerticalAlignment = .center
}

struct InputDropdownViewModel<T> {
  var name: String
  var label: String
  var options: [Option<T>] = []
  var selectedOption: Option<T>?
  var defaultOption: Option<T>?
  var requiered: Bool?
  var inputAttributes: InputAttributes = .init()
  var errors: [ErrorSchema] = []
  var activeErrors: [FormFieldError] = []
  var delegate: InputDropdownDelegate?
  var onSelectValue: Observable<T?> {
    self._onSelectValue.asObserver()
  }

  private let _onSelectValue = BehaviorSubject<T?>(value: nil)

  mutating func setSelectedOption(_ option: Option<T>?) {
    self.selectedOption = option
    self._onSelectValue.onNext(option?.value)
  }
}
