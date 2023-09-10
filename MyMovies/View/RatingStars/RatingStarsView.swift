//
//  RatingStartsView.swift
//  MyMovie
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit
import RxSwift

class RatingStarsView: UIView {
  @IBOutlet private var starImageViewList: [UIImageView]!

  private var viewMode = RatingStarsViewModel()

  private let disposeBag = DisposeBag()

  var delegate: RatingStarsDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()

    for starImageView in starImageViewList {
      let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
      tapGestureRecognizer.numberOfTapsRequired = 1
      starImageView.addGestureRecognizer(tapGestureRecognizer)
      starImageView.isUserInteractionEnabled = true
    }

    viewMode.onChangeValue.subscribe(
      onNext: {[weak self] stars in
        if let delegate = self?.delegate {
          delegate.onChangeValue?(stars)
        }
      }
    ).disposed(by: disposeBag)
  }

  func updateStarsView() {
    guard let delegate = self.delegate else { fatalError("delegate must be implemented") }

    if let starImageViewList = starImageViewList {
      for starImageView in starImageViewList {
        if delegate.markedStars > 0 && starImageView.tag < delegate.markedStars {
          starImageView.image = UIImage(named: "Marked Star")
        } else {
          starImageView.image = UIImage(named: "Unmarked Star")
        }
      }
    }
  }

  @objc func imageTapped(_ sender: UITapGestureRecognizer) {
    guard let delegate = self.delegate else { fatalError("delegate must be implemented") }

    if !delegate.readOnly {
      if let imageView = sender.view as? UIImageView {
        let newValue = imageView.tag + 1
        if newValue != delegate.markedStars {
          self.viewMode.changeValue(newValue)
          self.updateStarsView()
        }
      }
    }
  }
}

