//
//  UISheetView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 09/09/23.
//

import UIKit

class UISheetView: UIViewController {
  private(set) var mainView = UIView()
  private(set) var contentStackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  func addContentView(_ view: UIView) {
    self.contentStackView.addArrangedSubview(view)
  }

  private func configureView() {
    view.backgroundColor = .black.withAlphaComponent(0.3)

    mainView.layer.backgroundColor = .init(red: 1, green: 1, blue: 1, alpha: 1)

    mainView.layer.cornerRadius = 24
    mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    mainView.addSubview(contentStackView)
    view.addSubview(mainView)

    mainView.translatesAutoresizingMaskIntoConstraints = false
    contentStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
      mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      mainView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4),
      contentStackView.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 30),
      contentStackView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 10),
      contentStackView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -10),
      contentStackView.bottomAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.bottomAnchor, constant: UIDevice.current.userInterfaceIdiom == .phone ? 0 : -10),
    ])
  }
}
