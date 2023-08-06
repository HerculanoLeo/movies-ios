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

  var movieImage: UIImage?

  func configureCell(_ model: MovieTableViewModel) {
    self.mainView.layer.cornerRadius = 24

    mainView.layer.masksToBounds = true

    movieNameLabel.text = model.movieName

    if let image = movieImage {
      movieImageView.image = image
    } else {
      UIImage.fromURLString(url: model.movieImageLink) { image in
        if image != nil {
          DispatchQueue.main.async {
            self.movieImage = image
            self.movieImageView.image = image
            self.movieImageView.contentMode = .scaleAspectFill
          }
        }
      }
    }
  }
}
