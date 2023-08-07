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

  let onChangeValue = BehaviorSubject<Int>(value: 0)

  var disposable: Disposable?

  @IBOutlet var starImageViewList: [UIImageView]!

  var readOnly = true

  deinit {
    self.disposable?.dispose()
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    for starImageView in starImageViewList {
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
      tapGestureRecognizer.numberOfTapsRequired = 1
      starImageView.addGestureRecognizer(tapGestureRecognizer)
      starImageView.isUserInteractionEnabled = true
    }

    self.disposable = self.onChangeValue.subscribe(onNext: {
      [weak self] newValue in
      if let starImageViewList = self?.starImageViewList {
        for starImageView in starImageViewList {
          if newValue > 0 && starImageView.tag < newValue {
            starImageView.image = UIImage(named: "Marked Star")
          } else {
            starImageView.image = UIImage(named: "Unmarked Star")
          }
        }
      }
    })
  }

  func configureView(_ model: RatingStarsViewModel) {
    self.readOnly = model.readOnly
    self.onChangeValue.onNext(model.markedStars)
  }

  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    if !self.readOnly {
      if let imageView = sender.view as? UIImageView {
        self.onChangeValue.onNext(imageView.tag + 1)
      }
    }
  }
}
