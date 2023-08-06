//
//  UIImage+Extension.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//

import Foundation
import UIKit

extension UIImage {
  class func fromURLString(url: String, completion: @escaping (UIImage?) -> Void) {
    if let urlRequest = URL(string: url) {
      let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        guard let data = data, error == nil else {
          completion(nil)
          return
        }
        let image = UIImage(data: data)
        completion(image)
      }

      task.resume()
    }
  }
}
