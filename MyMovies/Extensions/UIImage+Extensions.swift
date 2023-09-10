//
//  UIImage+Extension.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//

import Foundation
import UIKit

extension UIImage {
  class func fromURLString(string: String, completion: @escaping (UIImage?) -> Void) {
    if let url = URL(string: string) {
      let task = URLSession.shared.dataTask(with: url) { data, response, error in
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

  class func fromURLString(_ urlStr: String) async -> UIImage? {
    if let url = URL(string: urlStr) {
      do {
        let (data, _) = try await URLSession.shared.data(from: url);
        return UIImage(data: data)
      } catch {
        return nil
      }
    }
    return nil;
  }
}
