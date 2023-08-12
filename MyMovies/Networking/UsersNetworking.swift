//
//  UsersService.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import Alamofire

class UsersNetworking {
  class func findByid(id: String, completion: @escaping (Result<User, AFError>) -> Void) {
    guard var url = URLComponents(url: EnvironmentsVariables.shared.baseUrl, resolvingAgainstBaseURL: true) else {
      fatalError("Error to generate URLComponents")
    }
    url.path = "/users/\(id)"
    AF.request(url).responseDecodable(of: User.self) { response in
      completion(response.result)
    }
  }
}


