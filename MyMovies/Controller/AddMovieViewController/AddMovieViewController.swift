//
//  AddMovieViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 12/08/23.
//

import UIKit
import RxSwift
import RxCocoa

class AddMovieViewController: UIViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var mainStackView: UIStackView!

  var delegate: AddMovieDelegate?
  
  private var activeTextField: UIView?

  private var movieRequest = MovieRegisterRequest(name: "", ageGroup: "")

  private let disposeBag = DisposeBag()

  private let formControl = FormControl()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  private func configureView() {
    navigationController?.navigationBar.barTintColor = .black
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.alpha = 0
    
    navigationController?.navigationBar.tintColor = UIColor.black
    navigationController?.navigationBar.barStyle = UIBarStyle.black
    
    let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    scrollView.addGestureRecognizer(endEditingGesture)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    let titleInput = UIInputTextView(.init(
      name: "title",
      label: "Titulo",
      requiered: true,
      errors: [.init(error: MovieRegisterRequest.Error.name, message: "Título é obrigatório")]
    ))
    titleInput.setTextFieldDelegate(self)
    
    let synopsysInput = UIInputTextAreaView(.init(
      name: "synopsys",
      label: "Sinopse",
      errors: [.init(error: MovieRegisterRequest.Error.synopsys, message: "Sinopse deve ter ao menos 5 letras")]
    ))
    synopsysInput.setTextViewDelegate(self)
    
    let ageGroupInput = UIInputDropdownView<String>(.init(
      name: "ageGroup",
      label: "Classificação Etaria",
      options: [
        .init(label: "Livre", value: "Livre"),
        .init(label: "12 anos", value: "12 anos"),
        .init(label: "14 anos", value: "14 anos"),
        .init(label: "18 anos", value: "18 anos"),
      ],
      selectedOption: .init(label: "Selecione uma opção", value: nil),
      requiered: true,
      errors: [.init(error: MovieRegisterRequest.Error.ageGroup, message: "Classificação Etaria é obrigatório")],
      delegate: self
    ))

    let coverInput = UIInputTextView(.init(
      name: "movieCoverUrl",
      label: "Miniatura",
      errors: [.init(error: MovieRegisterRequest.Error.movieCoverUrl, message: "Url inválida")]
    ))
    coverInput.setTextFieldDelegate(self)
    
    let wallpaperInput = UIInputTextView(.init(
      name: "movieWallpaperUrl",
      label: "Wallpaper",
      errors: [.init(error: MovieRegisterRequest.Error.movieWallpaperUrl, message: "Url inválida")]
    ))
    wallpaperInput.setTextFieldDelegate(self)
    
    guard let ratingStarsView = Bundle.main.loadNibNamed("RatingStarsView", owner: nil)?.first as? RatingStarsView else {
      fatalError("Error to create a RatingStarsView")
    }
    ratingStarsView.delegate = self

    let saveButton = UIButton()
    saveButton.backgroundColor = UIColor(red: 84/255, green: 101/255, blue: 255/255, alpha: 1)
    saveButton.setTitle("Salvar", for: .normal)
    saveButton.setTitleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
    saveButton.addConstraint(NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60))
    saveButton.layer.cornerRadius = 24
    saveButton.layer.masksToBounds = true

    mainStackView.addArrangedSubview(titleInput)
    mainStackView.addArrangedSubview(synopsysInput)
    mainStackView.addArrangedSubview(ageGroupInput)
    mainStackView.addArrangedSubview(coverInput)
    mainStackView.addArrangedSubview(wallpaperInput)
    mainStackView.addArrangedSubview(ratingStarsView)
    mainStackView.addArrangedSubview(saveButton)

    formControl.addAll([
      titleInput,
      synopsysInput,
      ageGroupInput,
      coverInput,
      wallpaperInput
    ])

    titleInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in
      self?.movieRequest.name = text
    }).disposed(by: disposeBag)

    synopsysInput.textField.rx.text.orEmpty
      .map { text -> String? in text.isEmpty ? nil : text }
      .subscribe(onNext: { [weak self] text in
        self?.movieRequest.synopsys = text
      }).disposed(by: disposeBag)

    ageGroupInput.onSelectValue
      .map { value in (value != nil) ? value! : "" }
      .subscribe {[weak self] event in
        switch event{
        case .next(let value):
          self?.movieRequest.ageGroup = value
        default:
          break
        }
      }.disposed(by: disposeBag)

    coverInput.textField.rx.text.orEmpty
      .map { text -> String? in text.isEmpty ? nil : text }
      .subscribe(onNext: { [weak self] text in
        self?.movieRequest.movieCoverUrl = text
      }).disposed(by: disposeBag)

    wallpaperInput.textField.rx.text.orEmpty
      .map { text -> String? in text.isEmpty ? nil : text }
      .subscribe(onNext: { [weak self] text in
        self?.movieRequest.movieWallpaperUrl = text
      }).disposed(by: disposeBag)

    saveButton.rx.tap.subscribe(onNext: { [weak self] _ in
      self?.save()
    }).disposed(by: disposeBag)
  }

  func save() {
    formControl.cleanErrors()
    let result = addMovieConstraints.evaluate(with: movieRequest)
    if case .failure(let summary) = result {
      formControl.setErrors(summary.errors)
      return
    }
    MovieApiResource.register(requestEntity: movieRequest) {[weak self] result in
      switch result {
      case .success(let movie):
        print(movie.id)
        self?.delegate?.onMovieRegistered()
        self?.navigationController?.popViewController(animated: true)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
      
      var visibleRect = self.view.frame
      visibleRect.size.height -= keyboardSize.height
      if let activeField = activeTextField, !visibleRect.contains(activeField.frame.origin) {
        scrollView.scrollRectToVisible(activeField.frame, animated: true)
      }
    }
  }
  
  @objc func keyboardWillHide(_ notification: Notification) {
    scrollView.contentInset = .zero
    scrollView.scrollIndicatorInsets = .zero
  }
  
  @objc func dismissKeyboard() {
    self.scrollView.endEditing(true)
  }
}

extension AddMovieViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    activeTextField = textField
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    activeTextField = nil
  }
}

extension AddMovieViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    activeTextField = textView
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    activeTextField = nil
  }
}

extension AddMovieViewController: RatingStarsDelegate {
  var markedStars: Int {
    return movieRequest.stars
  }

  var readOnly: Bool {
    return false
  }

  func onChangeValue(_ stars: Int) {
    movieRequest.stars = stars
  }

}

extension AddMovieViewController: InputDropdownDelegate {
  func showOptions(_ optionsView: some UIView) {
    showSheetModalView(optionsView)
  }

  func hideOptions() {
    hideModal()
  }
}
