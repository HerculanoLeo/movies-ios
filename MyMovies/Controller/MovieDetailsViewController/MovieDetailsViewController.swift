//
//  MovieDetailsViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit
import RxSwift

class MovieDetailsViewController: UIViewController {
  private let viewModel = MovieDetailsViewModel()

  @IBOutlet private weak var wallpaperImageView: UIImageView!

  @IBOutlet private weak var movieNameLabel: UILabel!

  @IBOutlet private weak var sysnopsisMovieLabel: UILabel!

  @IBOutlet private weak var ageGroupLabel: UILabel!

  @IBOutlet private weak var ratingStarsCardView: UIView!

  private var ratingStarsView: RatingStarsView?

  private var movieSubscription: Disposable?

  weak var delegate: MovieDetailsDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    fetchData()
  }

  deinit {
    self.movieSubscription?.dispose()
  }

  private func configureView() {
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.alpha = 0

    guard let ratingStarsView = Bundle.main.loadNibNamed("RatingStarsView", owner: nil)?.first as? RatingStarsView else {
      fatalError("Error to create a RatingStarsView")
    }
    ratingStarsView.delegate = self
    ratingStarsCardView.addSubview(ratingStarsView)

    self.ratingStarsView = ratingStarsView

    self.movieSubscription = self.viewModel.onMovieChange.subscribe(
      onNext: {[weak self] movie in
        self?.movieNameLabel.text = movie.name
        self?.sysnopsisMovieLabel.text = movie.synopsys
        self?.ageGroupLabel.text = movie.ageGroup

        self?.ratingStarsView?.updateStarsView()

        UIImage.fromURLString(urlStr: movie.movieWallpaperUrl) { image in
          DispatchQueue.main.async {
            self?.wallpaperImageView.image = image
            self?.wallpaperImageView.contentMode = .scaleAspectFill
          }
        }
      },
      onError: { error in
        print(error.localizedDescription)
      }
    )
  }

  private func fetchData() {
    guard let delegate = self.delegate else { fatalError("Delegate must be implemented") }
    self.viewModel.fetchMovie(movieId: delegate.movieSelectedId)
  }

}

extension MovieDetailsViewController: RatingStarsDelegate {
  var markedStars: Int {
    return self.viewModel.movie?.stars ?? 0
  }

  var readOnly: Bool {
    return false
  }

  func onChangeValue(_ stars: Int) {
    if let movie = self.viewModel.movie {
      let requestEntity = MovieUpdateRequest(id: movie.id, name: movie.name, synopsys: movie.synopsys, ageGroup: movie.ageGroup, stars: stars, movieCoverUrl: movie.movieCoverUrl, movieWallpaperUrl: movie.movieWallpaperUrl)
      MovieAPI.update(id: movie.id, requestEntity: requestEntity) {[weak self] response in
        self?.fetchData()
        self?.delegate?.onMovieUpdate()
      }
    }
  }
}
