//
//  MovieTableViewCell.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
  private var viewMode: MovieTableViewModel?

  @IBOutlet weak var mainView: UIView!

  @IBOutlet weak var movieImageView: UIImageView!

  @IBOutlet weak var movieNameLabel: UILabel!

  @IBOutlet weak var ratingStarsStackView: UIStackView!

  private var ratingStarsView: RatingStarsView?

  override func awakeFromNib() {
    super.awakeFromNib()

    guard let ratingStarsView = Bundle.main.loadNibNamed("RatingStarsView", owner: self)?.first as? RatingStarsView else { fatalError("error to create a RatingStarsView") }
    ratingStarsView.delegate = self

    self.ratingStarsView = ratingStarsView

    ratingStarsStackView.addArrangedSubview(ratingStarsView)
  }

  func configureCell(_ model: MovieTableViewModel) {
    self.viewMode = model;

    self.mainView.layer.cornerRadius = 24

    mainView.layer.masksToBounds = true

    movieNameLabel.text = model.name

    self.movieImageView.image = UIImage(named: "Logo")

    if let imageUrl = model.imageUrl {
      UIImage.fromURLString(urlStr: imageUrl) { image in
        if image != nil {
          DispatchQueue.main.async {
            self.movieImageView.image = image
            self.movieImageView.contentMode = .scaleAspectFill
          }
        }
      }
    }

    if let ratingStarsView = self.ratingStarsView {
      ratingStarsView.updateStarsView()
    }
  }
}

extension MovieTableViewCell: RatingStarsDelegate {
  var markedStars: Int {
    return self.viewMode?.stars ?? 0
  }

  var readOnly: Bool {
    return true
  }


}
