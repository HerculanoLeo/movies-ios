//
//  MovieNetworking.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import Alamofire

class MovieNetworking {
  class func findAll(completion: @escaping (Result<[Movie], AFError>) -> Void) {
    guard var url = URLComponents(url: EnvironmentsVariables.shared.baseUrl, resolvingAgainstBaseURL: true) else {
      fatalError("Error to generate URLComponents")
    }
    url.path = "/movies"
    AF.request(url).responseDecodable(of: [Movie].self) { response in
      completion(response.result)
    }
  }
}
