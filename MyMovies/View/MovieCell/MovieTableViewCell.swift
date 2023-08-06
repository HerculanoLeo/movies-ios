//
//  MovieTableViewCell.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

  @IBOutlet weak var mainView: UIView!

  @IBOutlet weak var movieImageView: UIImageView!

  @IBOutlet weak var movieNameLabel: UILabel!

  @IBOutlet weak var ratingStarsStackView: UIStackView!

  private var movieImage: UIImage?

  private var ratingStarsView: RatingStarsView?

  override func awakeFromNib() {
    super.awakeFromNib()

    guard let ratingStarsView = Bundle.main.loadNibNamed("RatingStarsView", owner: self)?.first as? RatingStarsView else { fatalError("error to create a RatingStarsView") }

    self.ratingStarsView = ratingStarsView

    ratingStarsStackView.addArrangedSubview(ratingStarsView)
  }

  func configureCell(_ model: MovieTableViewModel) {
    self.mainView.layer.cornerRadius = 24

    mainView.layer.masksToBounds = true

    movieNameLabel.text = model.name

    if let image = movieImage {
      movieImageView.image = image
    } else {
      UIImage.fromURLString(url: model.imageUrl) { image in
        if image != nil {
          DispatchQueue.main.async {
            self.movieImage = image
            self.movieImageView.image = image
            self.movieImageView.contentMode = .scaleAspectFill
          }
        }
      }
    }
    
    if let ratingStarsView = self.ratingStarsView {
      ratingStarsView.configureView(RatingStarsViewModel(stars: model.stars))
    }
  }
}
