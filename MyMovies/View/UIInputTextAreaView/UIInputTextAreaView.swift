//
//  UIInputTextAreaView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 14/08/23.
//

import Foundation
import UIKit

class UIInputTextAreaView: UIStackView {
  private let viewMode: InputViewModel
  private(set) var label = UILabel()
  private(set) var textField = UIInputTextAreaField()

  init(_ viewMode: InputViewModel) {
    self.viewMode = viewMode
    super.init(frame: CGRect())
    commonInit()
  }

  override init(frame: CGRect) {
      self.viewMode = InputViewModel(label: "")
      super.init(frame: frame)
      commonInit()
  }

  required init(coder: NSCoder) {
      self.viewMode = InputViewModel(label: "")
      super.init(coder: coder)
      commonInit()
  }

  func setTextViewDelegate(_ delegate: UITextViewDelegate) {
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
    self.textField.addConstraint(NSLayoutConstraint(item: textField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 155))
    self.textField.layer.cornerRadius = 24
    self.textField.layer.masksToBounds = true
    self.textField.font = UIFont.systemFont(ofSize: 16)
    self.textField.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    self.textField.textContainerInset = .init(top: 10, left: 15, bottom: 10, right: 15)

    self.label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    self.label.font = UIFont.boldSystemFont(ofSize: 16)
  }
}

class UIInputTextAreaField: UITextView {

}
