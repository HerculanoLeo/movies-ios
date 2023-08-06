//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  private var headerUserView: HomeHeaderView?

  private var moviesList: [Movie]? = movies

  private var loggedUser: User = user

  private var movieSelected: Movie?

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView()
  }

  private func configureView() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    tableView.backgroundColor = UIColor(red: 224/255, green: 229/255, blue: 255/255, alpha: 1)
    tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(section == 0) {
      return 0
    } else {
      return moviesList?.count ?? 0
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if(section == 0) {
      return 110
    } else {
      return 32
    }
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    return 0.1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let movies = moviesList {
      let movie = movies[indexPath.row]
      guard let movieCellView = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell else {
        fatalError("Fail to create MovieTableViewCell")
      }
      movieCellView.configureCell(MovieTableViewModel(name: movie.name, imageUrl: movie.movieCoverLink, stars: movie.stars))
      movieCellView.selectionStyle = .none
      return movieCellView
    } else {
      fatalError("Fail to take movie from movies")
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 {
      return 140
    }
    return 0
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      guard let movie = moviesList?[indexPath.row] else { fatalError("error to take a movie in movieList by indexPath") }
      self.selectMovie(movie)
      let movieDetailsViewContoller = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
      movieDetailsViewContoller.delegate = self
      self.navigationController?.pushViewController(movieDetailsViewContoller, animated: true)
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      if self.headerUserView == nil {
        guard let headerUserView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as? HomeHeaderView else { fatalError("fail to instanciete an HomeHeaderView") }
        headerUserView.configureView(HomeHeaderViewModel(userName: loggedUser.name, userImageUrl: loggedUser.profileImageUrl))
        self.headerUserView = headerUserView
      }
      return self.headerUserView
    } else {
      guard let movieTitleHeaderView = Bundle.main.loadNibNamed("MoviesTitleHeaderView", owner: self)?.first as? UIView else {
        fatalError("fail to instanciete an MoviesTitleHeaderView")
      }
      return movieTitleHeaderView
    }
  }
}

extension HomeViewController: MovieDetailsDelegate {
  var movieModelSelected: MovieDetailsViewModel {
    if let movie = self.movieSelected {
      return MovieDetailsViewModel(id: movie.id, name: movie.name, synopsis: movie.synopsis, ageGroup: movie.ageGroup, stars: movie.stars, wallpaperUrl: movie.movieWallpaper)
    }
    return MovieDetailsViewModel(id: nil, name: "", synopsis: "", ageGroup: "", stars: 0, wallpaperUrl: "")
  }

  func selectMovie(_ movie: Movie) {
    self.movieSelected = movie
  }

}
