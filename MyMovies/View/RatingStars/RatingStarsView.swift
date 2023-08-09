//
//  RatingStartsView.swift
//  MyMovie
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit
import RxSwift
import RxCocoa

class RatingStarsView: UIView {

  var markedStar = 0

  let onChangeValue = PublishSubject<Int>()

  @IBOutlet var starImageViewList: [UIImageView]!

  var readOnly = true

  override func awakeFromNib() {
    super.awakeFromNib()

    for starImageView in starImageViewList {
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
      tapGestureRecognizer.numberOfTapsRequired = 1
      starImageView.addGestureRecognizer(tapGestureRecognizer)
      starImageView.isUserInteractionEnabled = true
    }

  }

  func configureView(_ model: RatingStarsViewModel) {
    self.readOnly = model.readOnly
    self.markedStar = model.markedStars
    self.updateStarsView()
  }

  func updateStarsView() {
    if let starImageViewList = starImageViewList {
      for starImageView in starImageViewList {
        if markedStar > 0 && starImageView.tag < markedStar {
          starImageView.image = UIImage(named: "Marked Star")
        } else {
          starImageView.image = UIImage(named: "Unmarked Star")
        }
      }
    }
  }

  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    if !self.readOnly {
      if let imageView = sender.view as? UIImageView {
        let newValue = imageView.tag + 1
        if newValue != markedStar {
          markedStar = newValue
          self.updateStarsView()
          self.onChangeValue.onNext(newValue)
        }
      }
    }
  }
}

