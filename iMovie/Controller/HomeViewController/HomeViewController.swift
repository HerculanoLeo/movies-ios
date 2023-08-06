//
//  ViewController.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 02/08/23.
//

import UIKit

class HomeViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  private var headerUserView: HomeHeaderView?

  private let movies: [MovieTableViewModel]? = [
    MovieTableViewModel(movieName: "Os Vingadores", movieImageLink: "https://www.themoviedb.org/t/p/original/j9hwS307Zlc5mQTbAnwV75vXG0H.jpg", starts: 5),
    MovieTableViewModel(movieName: "Vingadores: Era de Ultron", movieImageLink: "https://cinergetica.com.mx/wp-content/uploads/2015/02/avengers-era-ultron-poster.jpg", starts: 3),
    MovieTableViewModel(movieName: "Vingadores: Guerra Infinita", movieImageLink: "https://image.tmdb.org/t/p/original/hDOGxIKAZbnF71oO0sZG7rJuJZt.jpg", starts: 4),
    MovieTableViewModel(movieName: "Vingadores: Ultimato", movieImageLink: "https://image.tmdb.org/t/p/original/mI1Ktgg7LuhwAhUgke4rHUxlDUr.jpg", starts: 3),
    MovieTableViewModel(movieName: "Homem de Ferro", movieImageLink: "https://image.tmdb.org/t/p/original/tAcDOFX0WludQhvTdmG2rDxyQRM.jpg", starts: 5),
    MovieTableViewModel(movieName: "Homem de Ferro 3", movieImageLink: "https://www.cafecomfilme.com.br/media/k2/items/cache/fe8bfc1b99c9ede76699e9aaec65452f_XL.jpg?t=1543089694", starts: 2),
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    self.configureView()
  }

  private func configureView() {
    tableView.backgroundColor = UIColor(red: 224/255, green: 229/255, blue: 255/255, alpha: 1)
    tableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
  }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(section == 0) {
      return 0
    } else {
      return movies?.count ?? 0
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
    if let movies = movies {
      let movie = movies[indexPath.row]
      guard let movieCellView = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell else {
        fatalError("Fail to create MovieTableViewCell")
      }
      movieCellView.configureCell(movie)
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

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      if self.headerUserView == nil {
        guard let headerUserView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as? HomeHeaderView else { fatalError("fail to instanciete an HomeHeaderView") }
        headerUserView.configureView(HomeHeaderViewModel(userName: "Georde Phoenix", imageLink: "https://photografos.com.br/wp-content/uploads/2020/09/fotografia-para-perfil.jpg"))
        self.headerUserView = headerUserView
      }
      return self.headerUserView
    } else {
      guard let movieTitleHeaderView = Bundle.main.loadNibNamed("MoviesTitleHeaderView", owner: self)?.first as? MoviesTitleHeaderView else {
        fatalError("fail to instanciete an MoviesTitleHeaderView")
      }
      return movieTitleHeaderView
    }
  }
}
