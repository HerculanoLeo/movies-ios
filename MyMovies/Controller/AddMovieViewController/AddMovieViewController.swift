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

  private var movieRequest = MovieRegisterRequest()

  private var subs: [Disposable] = []

  deinit {
    subs.forEach({ sub in sub.dispose() })
  }
  
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
    
    let titleInput = UIInputTextView(.init(label: "Titulo", requiered: true))
    titleInput.setTextFieldDelegate(self)
    
    let synopsysInput = UIInputTextAreaView(.init(label: "Sinopse", requiered: true))
    synopsysInput.setTextViewDelegate(self)
    
    let ageGroupInput = UIInputTextView(.init(label: "Classificação Etaria", requiered: true))
    ageGroupInput.setTextFieldDelegate(self)
    
    let coverInput = UIInputTextView(.init(label: "Miniatura", requiered: true))
    coverInput.setTextFieldDelegate(self)
    
    let wallpaperInput = UIInputTextView(.init(label: "Wallpaper", requiered: true))
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

    subs.append(titleInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in self?.movieRequest.name = text }))
    subs.append(synopsysInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in self?.movieRequest.synopsys = text }))
    subs.append(ageGroupInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in self?.movieRequest.ageGroup = text }))
    subs.append(coverInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in self?.movieRequest.movieCoverUrl = text }))
    subs.append(wallpaperInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in self?.movieRequest.movieWallpaperUrl = text }))
    subs.append(titleInput.textField.rx.text.orEmpty.subscribe(onNext: { [weak self] text in self?.movieRequest.name = text }))
    subs.append(saveButton.rx.tap.subscribe(onNext: { [weak self] _ in self?.save() }))
  }

  func save() {
    MovieAPI.register(requestEntity: movieRequest) {[weak self] result in
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
