//
//  MovieDetailsViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit
import RxSwift

class MovieDetailsViewController: UIViewController {

  @IBOutlet weak var wallpaperImageView: UIImageView!

  @IBOutlet weak var movieNameLabel: UILabel!

  @IBOutlet weak var sysnopsisMovieLabel: UILabel!

  @IBOutlet weak var ageGroupLabel: UILabel!

  @IBOutlet weak var ratingStarsCardView: UIView!

  var delegate: MovieDetailsDelegate?

  var wallpaperImage: UIImage?

  var retingStarsSubscription: Disposable?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }

  deinit {
    self.retingStarsSubscription?.dispose()
  }

  func configureView() {
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.alpha = 0

    guard let delegate = self.delegate else { fatalError("Delegate must be implemented") }
    let model = delegate.movieModelSelected;

    movieNameLabel.text = model.name
    sysnopsisMovieLabel.text = model.synopsis
    ageGroupLabel.text = model.ageGroup

    guard let ratingStarsView = Bundle.main.loadNibNamed("RatingStarsView", owner: nil)?.first as? RatingStarsView else {
      fatalError("Error to create a RatingStarsView")
    }

    ratingStarsView.configureView(RatingStarsViewModel(stars: model.stars, readOnly: false))

    retingStarsSubscription = ratingStarsView.onChangeValue.subscribe(onNext: {
      [weak self] newValue in print("Valor trocou \(newValue)")
    })

    ratingStarsCardView.addSubview(ratingStarsView)

    if let image = wallpaperImage {
      wallpaperImageView.image = image
    } else {
      UIImage.fromURLString(url: model.wallpaperUrl) { image in
        if image != nil {
          DispatchQueue.main.async {
            self.wallpaperImage = image
            self.wallpaperImageView.image = image
            self.wallpaperImageView.contentMode = .scaleAspectFill
          }
        }
      }
    }
  }

}
