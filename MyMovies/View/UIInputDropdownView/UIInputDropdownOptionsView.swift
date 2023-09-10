//
//  UIInputOneMenuSelectOptionsView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 09/09/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

typealias OnSelectOption<T> = (_ option: Option<T>?) -> Void

class UIInputDropdownOptionsView<T>: UIView, UITableViewDataSource, UITableViewDelegate {
  private(set) var options: [Option<T>] = []
  private(set) var optionsTableView = UITableView()
  private(set) var cancelButton: UIButton = {
    let button = UIButton()

    button.layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 24

    button.setTitle("Cancelar", for: .normal)
    button.setTitleColor(.red, for: .normal)

    return button
  }()
  private let disposeBag = DisposeBag()

  var delegate: InputDropdownDelegate?

  var onSelect: OnSelectOption<T>?

  init() {
    super.init(frame: CGRect())
    commonInit()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  func setOptions(_ options: [Option<T>]) {
    self.options = options
    self.optionsTableView.reloadData()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.options.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let option = self.options[indexPath.row]

    let optionLabel = UILabel()
    optionLabel.translatesAutoresizingMaskIntoConstraints = false
    optionLabel.text = option.label
    optionLabel.font = .boldSystemFont(ofSize: 14)
    optionLabel.textColor = .black
    optionLabel.textAlignment = .center

    let cell = UITableViewCell()
    cell.backgroundColor = .white

    cell.addSubview(optionLabel)

    NSLayoutConstraint.activate([
      optionLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor),
      optionLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor),
    ])

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let option = self.options[indexPath.row]
    if let onSelect = onSelect {
      onSelect(option)
    }
  }

  private func commonInit() {
    configureTableView()
    configureCancelButton()
    configureConstraints()
  }

  private func configureTableView() {
    self.addSubview(optionsTableView)
    optionsTableView.dataSource = self
    optionsTableView.delegate = self
  }

  private func configureCancelButton() {
    self.addSubview(cancelButton)
    cancelButton.rx.tap.subscribe { [weak self] _ in
      self?.delegate?.hideOptions()
    }.disposed(by: disposeBag)
  }

  private func configureConstraints() {
    optionsTableView.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cancelButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      cancelButton.heightAnchor.constraint(equalToConstant: 60),
      optionsTableView.topAnchor.constraint(equalTo: self.topAnchor),
      optionsTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      optionsTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      optionsTableView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -10),
    ])
  }
}

