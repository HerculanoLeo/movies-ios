//
//  HomeViewController.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!

  @IBOutlet weak var addMovieButton: UIButton!

  private let viewModel = HomeViewModel()

  private let refreshControl = UIRefreshControl()

  private var headerUserView: HomeHeaderView?

  private var disposeBag = DisposeBag()

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

    guard let headerUserView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as? HomeHeaderView else { fatalError("fail to instanciete an HomeHeaderView") }
    self.headerUserView = headerUserView
    self.headerUserView?.configureView(userId: "1")

    tableView.refreshControl = refreshControl

    refreshControl.rx.controlEvent(.valueChanged)
      .subscribe(onNext: { [weak self] in
        self?.refreshData()
      })
      .disposed(by: disposeBag)

    self.viewModel.onChangeMovies
      .subscribe(
        onNext: {[weak self] response in
          if case .error(_) = response {
            print("Erro ao consultar os filmes, verifique sua conexção")
            self?.showToast(message: "Erro ao consultar os filmes, verifique sua conexção")
          }
          self?.refreshControl.endRefreshing()
          self?.tableView.reloadData()
        }
      )
      .disposed(by: disposeBag)

    self.refreshData()

    addMovieButton.layer.cornerRadius = 28
    addMovieButton.layer.masksToBounds = true
    addMovieButton.rx.tap.subscribe({[weak self] _ in self?.navigateToAddMovie()}).disposed(by: disposeBag)
  }

  @objc func refreshData() {
    self.headerUserView?.configureView(userId: "1")
    self.viewModel.fetchMovies()
  }

  @objc func navigateToAddMovie() {
    let addMovieViewController = AddMovieFormViewController()
    addMovieViewController.delegate = self
    self.navigationController?.pushViewController(addMovieViewController, animated: true)
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
      return self.viewModel.movies.count
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
    let movie = self.viewModel.movies[indexPath.row]
    guard let movieCellView = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell") as? MovieTableViewCell else {
      fatalError("Fail to create MovieTableViewCell")
    }
    movieCellView.configureCell(MovieTableViewModel(name: movie.name, imageUrl: movie.movieCoverUrl, stars: movie.stars))
    movieCellView.selectionStyle = .none
    return movieCellView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 1 {
      return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone ? 140 : 440
    }
    return 0
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 1 {
      let movie = self.viewModel.movies[indexPath.row]
      self.viewModel.selectMovie(movie)
      let movieDetailsViewContoller = MovieDetailsViewController(nibName: "MovieDetailsViewController", bundle: nil)
      movieDetailsViewContoller.delegate = self.viewModel
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
      return self.headerUserView
    } else {
      guard let movieTitleHeaderView = Bundle.main.loadNibNamed("MoviesTitleHeaderView", owner: self)?.first as? UIView else {
        fatalError("fail to instanciete an MoviesTitleHeaderView")
      }
      return movieTitleHeaderView
    }
  }
}

extension HomeViewController: AddMovieDelegate {
  func onMovieRegistered() {
    self.refreshData()
  }
}
