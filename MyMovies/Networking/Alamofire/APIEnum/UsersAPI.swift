//
//  UsersService.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import Alamofire

private enum UsersEndpoints: NetworkIntegration {
  case findById(id: String)

  var httpMethod: HTTPMethod {
    switch self {
    case .findById:
      return .get
    }
  }

  var urlRequest: URL {
    var url = EnvironmentsVariables.shared.baseUrl

    switch self {
    case .findById(let id):
      url.path = "/users/\(id)"
    }
    return try! url.asURL()
  }

  var httpBody: Data? {
    return nil
  }
}

class UsersAPI {
  class func findByid(id: String, completion: @escaping (Result<User, AFError>) -> Void) {
    AF.request(UsersEndpoints.findById(id: id)).responseDecodable(of: User.self) { response in
      completion(response.result)
    }
  }
}


