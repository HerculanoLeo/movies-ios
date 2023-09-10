//
//  FormViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 10/09/23.
//

import UIKit
import RxSwift
import RxCocoa
import Peppermint

typealias WillSubmit = () -> Void
typealias OnSubmit<T> = (_ value: T) -> Void
typealias FailedSubmit = (_ error: FormError) -> Void

class UIFormViewController<T: Codable, E: FormFieldError>: UIViewController, UITextFieldDelegate, UITextViewDelegate, InputDropdownDelegate {

  private let scrollView = UIScrollView()

  private let mainStackView = UIStackView()

  private let titleView: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    return view
  }()

  private var activeViewField: UIView?

  private var dividerView: UIView {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      view.heightAnchor.constraint(equalToConstant: 1)
    ])
    return view
  }

  private let saveButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor(red: 84/255, green: 101/255, blue: 255/255, alpha: 1)
    button.setTitle("Salvar", for: .normal)
    button.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)

    button.layer.cornerRadius = 24
    button.layer.masksToBounds = true

    NSLayoutConstraint.activate([
      button.heightAnchor.constraint(equalToConstant: 60)
    ])

    return button
  }()

  let formControl = FormControl<T, E>()

  let disposeBag = DisposeBag()

  var willSubmit: WillSubmit?

  var onSubmit: OnSubmit<T>?

  var failedSubmit: FailedSubmit?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  func setTitle(_ title: String?) {
    if let title = title {
      let titleLabel = UILabel()
      titleLabel.text = title
      titleLabel.font = .boldSystemFont(ofSize: 32)
      titleLabel.textColor = .black
      titleLabel.textAlignment = .center

      titleView.addArrangedSubview(titleLabel)
    } else {
      for subview in titleView.arrangedSubviews {
        titleView.removeArrangedSubview(subview)
        subview.removeFromSuperview()
      }
    }
  }

  private func configureView() {
    view.layer.backgroundColor = .init(red: 224/255, green: 229/255, blue: 255/255, alpha: 1)

    navigationController?.navigationBar.barTintColor = .black
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.alpha = 0

    navigationController?.navigationBar.tintColor = UIColor.black
    navigationController?.navigationBar.barStyle = UIBarStyle.black

    configureKeyboard()
    configureScrollView()
    configureMainStackView()
  }

  private func configureKeyboard() {
    let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    scrollView.addGestureRecognizer(endEditingGesture)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func configureScrollView() {
    view.addSubview(scrollView)
    let divider = dividerView
    scrollView.addSubview(divider)
    scrollView.addSubview(mainStackView)
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    mainStackView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -30),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      divider.topAnchor.constraint(equalTo: scrollView.topAnchor),
      divider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      divider.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      divider.widthAnchor.constraint(equalTo: view.widthAnchor),
      mainStackView.topAnchor.constraint(equalTo: divider.bottomAnchor),
      mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 25),
      mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -25),
      mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
    ])
  }

  private func configureMainStackView() {
    mainStackView.axis = .vertical
    mainStackView.spacing = 15
  }

  public func build(_ formFieldBuilders: [FormFieldBuilder], _ formContrainst: TypeConstraint<T, E>?) {
    for subview in mainStackView.arrangedSubviews {
      mainStackView.removeArrangedSubview(subview)
      subview.removeFromSuperview()
    }

    mainStackView.addArrangedSubview(titleView)

    let inputs = formFieldBuilders.map { builder in builder.build() }

    inputs.forEach { input in
      if let inputView = input as? UIView {
        formControl.add(input)
        mainStackView.addArrangedSubview(inputView)
      }
    }

    if let formContrainst = formContrainst {
      formControl.setFormContraints(formContrainst)
    }

    mainStackView.addArrangedSubview(saveButton)

    saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
      self?.submit()
    }).disposed(by: disposeBag)
  }

  private func submit() {
    if let willSubmit = willSubmit {
      willSubmit()
    }

    let result = formControl.submit()

    switch result {
    case .success(let value):
      if let onSubmit = onSubmit {
        onSubmit(value)
      }
    case .failure(let error):
      if let failedSubmit = failedSubmit {
        failedSubmit(error)
      }
    }
  }

  @objc private func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets

      var visibleRect = self.view.frame
      visibleRect.size.height -= keyboardSize.height
      if let activeField = activeViewField, !visibleRect.contains(activeField.frame.origin) {
        scrollView.scrollRectToVisible(activeField.frame, animated: true)
      }
    }
  }

  @objc private func keyboardWillHide(_ notification: Notification) {
    scrollView.contentInset = .zero
    scrollView.scrollIndicatorInsets = .zero
  }

  @objc private func dismissKeyboard() {
    self.scrollView.endEditing(true)
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeViewField = textField
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    activeViewField = nil
  }

  func textViewDidBeginEditing(_ textView: UITextView) {
    activeViewField = textView
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    activeViewField = nil
  }

  func showOptions(_ optionsView: some UIView) {
    showSheetModalView(optionsView)
  }

  func hideOptions() {
    hideModal()
  }
}
