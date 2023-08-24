//
//  HomeHeaderView.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//
import Foundation
import UIKit
import RxSwift

class HomeHeaderView: UIView {
  private let viewModel = HomeHeaderViewModel()
  
  private let disposeBag = DisposeBag()
  
  @IBOutlet weak private var mainStackView: UIStackView!
  
  @IBOutlet weak private var userImageView: UIImageView!
  
  @IBOutlet weak private var greetingsLabel: UILabel!
  
  @IBOutlet weak private var userNameLabel: UILabel!
  
  private var image: UIImage?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    guard let dividerView = Bundle.main.loadNibNamed("DividerView", owner: self, options: nil)?.first as? UIView else {
      fatalError("fail to instanciete an DividerView")
    }
    self.mainStackView.addArrangedSubview(dividerView)
    self.greetingsLabel.text = self.viewModel.greetings
    self.viewModel.user.subscribe(
      onNext: {
        [weak self] result in
        switch result {
        case .success(let user):
          self?.userNameLabel.text = user.name
          if let image = self?.image {
            self?.userImageView.image = image
          } else if let imageLink = user.profileImageUrl {
            UIImage.fromURLString(urlStr: imageLink) { image in
              self?.image = image
              DispatchQueue.main.async {
                self?.userImageView.image = image
              }
            }
            self?.userImageView.layer.cornerRadius = 40
          }
        case .error(let error):
          print(error.localizedDescription)
        }
      }).disposed(by: disposeBag)
  }
  
  func configureView(userId: String) {
    self.viewModel.fetchUser(userId)
  }
}
