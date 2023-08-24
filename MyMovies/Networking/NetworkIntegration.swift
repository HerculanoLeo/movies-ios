//
//  API.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 23/08/23.
//

import Foundation
import Alamofire

protocol NetworkIntegration: URLRequestConvertible {
  var jsonEncoder: JSONEncoder { get }
  var httpMethod: HTTPMethod { get }
  var urlRequest: URL { get }
  var httpBody: Data? { get }
}

extension NetworkIntegration {
  var jsonEncoder: JSONEncoder {
    return JSONEncoder()
  }

  func asURLRequest() throws -> URLRequest {
    do {
      var request = try URLRequest(url: urlRequest, method: httpMethod)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = httpBody
      return request
    }catch {
      throw error
    }
  }
}


