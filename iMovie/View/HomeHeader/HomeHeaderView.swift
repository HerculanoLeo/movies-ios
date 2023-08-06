//
//  HomeHeaderView.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//
import Foundation
import UIKit

class HomeHeaderView: UIView {
  @IBOutlet weak var mainStackView: UIStackView!

  @IBOutlet weak var userImageView: UIImageView!

  @IBOutlet weak var greetingsLabel: UILabel!

  @IBOutlet weak var userNameLabel: UILabel!

  private var image: UIImage?

  func configureView(_ model: HomeHeaderViewModel) {
    self.userNameLabel.text = model.userName

    if let image = self.image {
      self.userImageView.image = image
    } else if let imageLink = model.imageLink {
      UIImage.fromURLString(url: imageLink) { image in
        self.image = image
        DispatchQueue.main.async {
          self.userImageView.image = image
        }
      }
      self.userImageView.layer.cornerRadius = 40
    }
    self.calcGreetingsLabel()

    guard let dividerView = Bundle.main.loadNibNamed("DividerView", owner: self, options: nil)?.first as? DividerView else { fatalError("fail to instanciete an DividerView") }

    mainStackView.addArrangedSubview(dividerView)
  }

  func calcGreetingsLabel() {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour], from: Date())
    if let hour = components.hour {
      if hour > 6 && hour < 12 {
        greetingsLabel.text = "Good morning!"
      } else if hour > 12 && hour < 18 {
        greetingsLabel.text = "Good afternoon!"
      } else {
        greetingsLabel.text = "Good evening!"
      }
    } else {
      greetingsLabel.text = "Welcome!"
    }
  }
  
}
