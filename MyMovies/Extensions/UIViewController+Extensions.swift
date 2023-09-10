//
//  UIViewController+Extensions.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 21/08/23.
//

import Foundation
import UIKit

extension UIViewController {

  func showToast(message: String) {
    let toastView = UIToastView(message: message)
    view.addSubview(toastView)
    view.bringSubviewToFront(toastView)

    toastView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      toastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
    ])

    UIView.animate(withDuration: 0.3, delay: 2.0, animations: {
      toastView.alpha = 0
    }) { _ in
      toastView.removeFromSuperview()
    }
  }

  func showSheetModalView(_ contentView: UIView?) {
    let sheetModalView = UISheetView()

    sheetModalView.modalTransitionStyle = .coverVertical
    sheetModalView.modalPresentationStyle = .overFullScreen
    self.present(sheetModalView, animated: true)

    if let contentView = contentView {
      sheetModalView.addContentView(contentView)
    }
  }

  func hideModal() {
    dismiss(animated: true)
  }

}
