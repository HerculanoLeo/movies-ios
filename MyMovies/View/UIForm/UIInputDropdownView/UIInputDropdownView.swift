//
//  UIInputMultiSelectView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 09/09/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UIInputDropdownView<T>: UIStackView {
  private var viewModel: InputDropdownViewModel<T>
  private(set) var label = UILabel()
  private(set) var selectValueButton = UIButton()
  private var errorMessages: [UILabel] = []
  private let selectedLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .boldSystemFont(ofSize: 14)
    label.textColor = .black
    label.textAlignment = .left
    return label
  }()
  private let disposeBag = DisposeBag()
  private let optionsView = UIInputDropdownOptionsView<T>()

  var onChangeValue: Observable<T?> {
    return self.viewModel.onSelectValue
  }

  init(_ viewMode: InputDropdownViewModel<T>) {
    self.viewModel = viewMode
    super.init(frame: CGRect())
    commonInit()
  }

  override init(frame: CGRect) {
    self.viewModel = InputDropdownViewModel<T>(name: "", label: "")
    super.init(frame: frame)
    commonInit()
  }

  required init(coder: NSCoder) {
    self.viewModel = InputDropdownViewModel<T>(name: "", label: "")
    super.init(coder: coder)
    commonInit()
  }

  func showOptions() {
    self.viewModel.delegate?.showOptions(self.optionsView)
  }

  private func commonInit() {
    self.axis = .vertical
    self.spacing = 15
    self.addArrangedSubview(label)
    self.addArrangedSubview(selectValueButton)

    if let required = viewModel.requiered, required == true {
      label.text = "\(viewModel.label) *"
    } else {
      label.text = viewModel.label
    }

    self.configureSelectValueButton();

    self.label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    self.label.font = UIFont.boldSystemFont(ofSize: 16)
  }

  private func configureSelectValueButton() {
    self.selectValueButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    self.selectValueButton.addConstraint(NSLayoutConstraint(item: selectValueButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: viewModel.inputAttributes.heigth))
    self.selectValueButton.layer.cornerRadius = 24
    self.selectValueButton.layer.masksToBounds = true
    self.selectValueButton.layer.borderWidth = 1

    selectValueButton.addSubview(selectedLabel)

    guard let arrowDownIcon = UIImage(systemName: "chevron.down") else { fatalError("fail to instanciate chevron.down") }
    let arrowDownIconView = UIImageView(image: arrowDownIcon)
    arrowDownIconView.translatesAutoresizingMaskIntoConstraints = false
    arrowDownIconView.tintColor = .black

    self.selectValueButton.addSubview(arrowDownIconView)

    NSLayoutConstraint.activate([
      arrowDownIconView.centerYAnchor.constraint(equalTo: self.selectValueButton.centerYAnchor),
      arrowDownIconView.trailingAnchor.constraint(equalTo: self.selectValueButton.trailingAnchor, constant: -25),
      arrowDownIconView.widthAnchor.constraint(equalToConstant: 20),
      selectedLabel.leadingAnchor.constraint(equalTo: self.selectValueButton.leadingAnchor, constant: 25),
      selectedLabel.trailingAnchor.constraint(equalTo: self.selectValueButton.trailingAnchor, constant: 25),
      selectedLabel.centerYAnchor.constraint(equalTo: self.selectValueButton.centerYAnchor),
    ])

    selectValueButton.rx.tap.subscribe {[weak self] _ in
      self?.showOptions()
    }
    .disposed(by: disposeBag)

    self.configureOptionsView()
    self.configureSelecedOption()
  }

  private func configureOptionsView() {
    self.optionsView.delegate = self.viewModel.delegate
    self.optionsView.onSelect = {[weak self] option in
      self?.viewModel.setSelectedOption(option)
      self?.configureSelecedOption()
      self?.viewModel.delegate?.hideOptions()
    }

    self.optionsView.setOptions(self.viewModel.options)
  }

  private func configureSelecedOption() {
    if let selectedOption = self.viewModel.selectedOption {
      self.selectedLabel.text = selectedOption.label
    } else {
      self.selectedLabel.text = ""
    }
  }

  func showErrors() {
    if self.viewModel.activeErrors.count > 0 {
      self.selectValueButton.layer.borderColor = UIColor.red.cgColor

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
      self.selectValueButton.layer.borderColor = UIColor.black.cgColor
      for errorMessage in errorMessages {
        errorMessage.removeFromSuperview()
      }
      self.errorMessages = []
    }
  }
}

extension UIInputDropdownView: FormField {
  var value: Any? {
    return self.viewModel.selectedOption?.value ?? self.viewModel.defaultOption?.value
  }

  var name: String {
    self.viewModel.name
  }

  var errors: [ErrorSchema] {
    self.viewModel.errors
  }

  var activeErrors: [FormFieldError] {
    self.viewModel.activeErrors
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
