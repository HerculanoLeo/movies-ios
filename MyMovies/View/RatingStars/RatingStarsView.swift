//
//  RatingStartsView.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit

class RatingStarsView: UIView {

  @IBOutlet var starImageViewList: [UIImageView]!

  func configureView(_ model: RatingStarsViewModel) {
    for starImageView in starImageViewList {
      if model.markedStars > 0 && starImageView.tag < model.markedStars {
        starImageView.image = UIImage(named: "Marked Star")
      } else {
        starImageView.image = UIImage(named: "Unmarked Star")
      }
    }

  }
}
