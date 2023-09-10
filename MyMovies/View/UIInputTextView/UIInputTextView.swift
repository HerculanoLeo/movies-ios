//
//  InputView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 12/08/23.
//

import UIKit

class UIInputTextView: UIStackView {
  private var viewMode: InputViewModel
  private(set) var label = UILabel()
  private(set) var textField = UIInputTextField()
  private var errorMessages: [UILabel] = []

  init(_ viewMode: InputViewModel) {
    self.viewMode = viewMode
    super.init(frame: CGRect())
    commonInit()
  }

  override init(frame: CGRect) {
    self.viewMode = InputViewModel(name: "", label: "")
    super.init(frame: frame)
    commonInit()
  }

  required init(coder: NSCoder) {
    self.viewMode = InputViewModel(name: "", label: "")
    super.init(coder: coder)
    commonInit()
  }

  func setTextFieldDelegate(_ delegate: UITextFieldDelegate) {
    self.textField.delegate = delegate
  }

  private func commonInit() {
    self.axis = .vertical
    self.spacing = 15
    self.addArrangedSubview(label)
    self.addArrangedSubview(textField)

    if let required = viewMode.requiered, required == true {
      label.text = "\(viewMode.label) *"
    } else {
      label.text = viewMode.label
    }

    self.textField.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    self.textField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    self.textField.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewMode.inputAttributes.heigth))
    self.textField.contentVerticalAlignment = viewMode.inputAttributes.contentVerticalAlignment
    self.textField.layer.cornerRadius = 24
    self.textField.layer.masksToBounds = true
    self.textField.layer.borderWidth = 1

    self.label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    self.label.font = UIFont.boldSystemFont(ofSize: 16)
  }

  func showErrors() {
    if self.viewMode.activeErrors.count > 0 {
      self.textField.layer.borderColor = UIColor.red.cgColor

      let errorSchemas = self.errors.filter {[weak self] schema in
        self?.activeErrors.contains(where: { active in
          active.fieldName == schema.error.fieldName
        }) ?? false
      }

      for errorSchema in errorSchemas {
        let message = UILabel()
        message.text = "* \(errorSchema.message)"
        message.textColor = .red
        message.font = UIFont.boldSystemFont(ofSize: 14)
        self.errorMessages.append(message)
        self.addArrangedSubview(message)
      }
    } else {
      self.textField.layer.borderColor = UIColor.black.cgColor
      for errorMessage in errorMessages {
        errorMessage.removeFromSuperview()
      }
      self.errorMessages = []
    }
  }

}

class UIInputTextField: UITextField {
  let padding = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
  override open func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: padding)
  }
}

extension UIInputTextView: FormField {
  var name: String {
    self.viewMode.name
  }

  var errors: [ErrorSchema] {
    self.viewMode.errors
  }

  var activeErrors: [FormFieldError] {
    self.viewMode.activeErrors
  }

  func focus() {
    self.textField.becomeFirstResponder()
  }

  func setActiveErrors(_ errors: [FormFieldError]) {
    self.viewMode.activeErrors = errors.filter {[weak self] error in
      self?.viewMode.errors.contains(where: { errorSchema in
        errorSchema.error.fieldName == error.fieldName
      }) ?? false
    }
    self.showErrors()
  }

  func cleanErrors() {
    self.viewMode.activeErrors = []
    self.showErrors()
  }
}
