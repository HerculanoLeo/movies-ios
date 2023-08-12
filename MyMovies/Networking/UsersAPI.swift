//
//  UsersService.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import Alamofire

private enum UsersEndpoints: URLRequestConvertible {
  case findById(id: String)

  var jsonEncoder: JSONEncoder {
    return JSONEncoder()
  }

  var httpMethod: HTTPMethod {
    switch self {
    case .findById:
      return .get
    }
  }

  var urlRequest: URL {
    guard var url = URLComponents(url: EnvironmentsVariables.shared.baseUrl, resolvingAgainstBaseURL: true) else {
      fatalError("Error to generate URLComponents")
    }
    do {
      switch self {
      case .findById(let id):
        url.path = "/users/\(id)"
        return try url.asURL()
      }
    } catch {
      fatalError("Error to generate URL")
    }
  }

  var httpBody: Data? {
    return nil
  }

  func asURLRequest() throws -> URLRequest {
    do {
      var request = try URLRequest(url: urlRequest, method: httpMethod)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = httpBody
      return request
    }catch {
      print(error.localizedDescription)
      throw error
    }
  }
}

class UsersAPI {
  class func findByid(id: String, completion: @escaping (Result<User, AFError>) -> Void) {
    AF.request(UsersEndpoints.findById(id: id)).responseDecodable(of: User.self) { response in
      completion(response.result)
    }
  }
}


