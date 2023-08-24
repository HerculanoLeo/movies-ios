//
//  ToastView.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 21/08/23.
//

import Foundation
import UIKit

class UIToastView: UIView {

  private let messageLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  init(message: String) {
    super.init(frame: CGRect())

    backgroundColor = UIColor.black.withAlphaComponent(0.7)
    layer.cornerRadius = 10
    clipsToBounds = true

    addSubview(messageLabel)
    messageLabel.text = message

    let maxWidth: CGFloat = UIScreen.main.bounds.width - 40

    let textSize = messageLabel.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))

    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: textSize.height + 20)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    messageLabel.frame = bounds
  }
}
