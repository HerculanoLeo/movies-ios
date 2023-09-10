//
//  UIInputRatingStarsView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 10/09/23.
//

import UIKit

class UIInputRatingStarsView: UIStackView {
  private var viewModel: InputRatingStarsViewModel
  private(set) var label = UILabel()
  private var starImageViewList: [UIImageView] = []
  private var errorMessages: [UILabel] = []

  init(_ viewMode: InputRatingStarsViewModel) {
    self.viewModel = viewMode
    super.init(frame: CGRect())
    commonInit()
  }

  override init(frame: CGRect) {
    self.viewModel = InputRatingStarsViewModel(name: "", label: "")
    super.init(frame: frame)
    commonInit()
  }

  required init(coder: NSCoder) {
    self.viewModel = InputRatingStarsViewModel(name: "", label: "")
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    self.axis = .horizontal
    self.spacing = 20
    self.alignment = .fill
    self.distribution = .fillEqually

    for i in 0...4 {
      let startUIImageView = UIImageView()
      startUIImageView.tag = i
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
      tapGestureRecognizer.numberOfTapsRequired = 1
      startUIImageView.addGestureRecognizer(tapGestureRecognizer)
      startUIImageView.isUserInteractionEnabled = true

      starImageViewList.append(startUIImageView)
      self.addArrangedSubview(startUIImageView)
    }

    NSLayoutConstraint.activate([
      self.heightAnchor.constraint(equalToConstant: viewModel.inputAttributes.heigth)
    ])

    updateStarsView()
  }

  func updateStarsView() {
    for starImageView in starImageViewList {
      if let markedStars = value as? Int, markedStars > 0 && starImageView.tag < markedStars {
        starImageView.image = UIImage(named: "Marked Star")
      } else {
        starImageView.image = UIImage(named: "Unmarked Star")
      }
    }
  }

  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    if let imageView = sender.view as? UIImageView {
      let newValue = imageView.tag + 1
      if newValue != viewModel.value {
        viewModel.value = newValue
        self.updateStarsView()
      }
    }
  }

  func showErrors() {
    if self.viewModel.activeErrors.count > 0 {
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
      for errorMessage in errorMessages {
        errorMessage.removeFromSuperview()
      }
      self.errorMessages = []
    }
  }
}

extension UIInputRatingStarsView: FormField {
  var name: String {
    return viewModel.name
  }

  var value: Any? {
    return self.viewModel.value ?? self.viewModel.defaultValue
  }

  var errors: [ErrorSchema] {
    return self.viewModel.errors
  }

  var activeErrors: [FormFieldError] {
    return self.viewModel.activeErrors
  }

  func focus() {
    self.becomeFirstResponder()
  }

  func setActiveErrors(_ errors: [FormFieldError]) {
    self.viewModel.activeErrors = errors.filter {[weak self] error in
      self?.viewModel.errors.contains(where: { errorSchema in
        errorSchema.error.fieldName == error.fieldName
      }) ?? false
    }
    self.showErrors()
  }

  func cleanErrors() {
    self.viewModel.activeErrors = []
    self.showErrors()
  }
}
