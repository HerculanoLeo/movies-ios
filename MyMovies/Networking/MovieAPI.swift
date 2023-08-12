//
//  MovieNetworking.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import Alamofire

private enum MovieEnpoints: URLRequestConvertible {
  case findAll
  case findById(id: String)
  case update(id: String, requestEntity: MovieRequestUpdate)

  var jsonEncoder: JSONEncoder {
    return JSONEncoder()
  }

  var httpMethod: HTTPMethod {
    switch self {
    case .findAll, .findById:
      return .get
    case.update:
      return .put
    }
  }

  var urlRequest: URL {
    guard var url = URLComponents(url: EnvironmentsVariables.shared.baseUrl, resolvingAgainstBaseURL: true) else {
      fatalError("Error to generate URLComponents")
    }
    do {
      switch self {
      case .findById(let id), .update(let id, _):
        url.path = "/movies/\(id)"
        return try url.asURL()

      case .findAll:
        url.path = "/movies"
        return try url.asURL()
      }
    } catch {
      fatalError("Error to generate URL")
    }
  }

  var httpBody: Data? {
    do {
      switch self {
      case .update(_, let requestEntity):
        return try jsonEncoder.encode(requestEntity)
      default:
        return nil
      }
    } catch {
      fatalError("Error to generate Body")
    }
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

class MovieAPI {
  class func findAll(completion: @escaping (Result<[Movie], AFError>) -> Void) {
    AF.request(MovieEnpoints.findAll).responseDecodable(of: [Movie].self) { response in
      completion(response.result)
    }
  }

  class func findById(id: String, completion: @escaping (Result<Movie, AFError>) -> Void) {
    AF.request(MovieEnpoints.findById(id: id)).responseDecodable(of: Movie.self) { response in
      completion(response.result)
    }
  }

  class func update(id: String, requestEntity: MovieRequestUpdate, completion: @escaping (Result<Data?, AFError>) -> Void) {
    AF.request(MovieEnpoints.update(id: id, requestEntity: requestEntity)).response { response in
      completion(response.result)
    }
  }
}
