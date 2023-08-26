//
//  MovieNetworking.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation
import Alamofire

private enum MovieEnpoints: NetworkIntegration {
  case findAll
  case register(requestEntity: MovieRegisterRequest)
  case findById(id: String)
  case update(id: String, requestEntity: MovieUpdateRequest)

  var httpMethod: HTTPMethod {
    switch self {
    case .findAll, .findById:
      return .get
    case.update:
      return .put
    case .register:
      return .post
    }
  }

  var urlRequest: URL {
    var url = EnvironmentsVariables.shared.baseUrl

    switch self {
    case .findById(let id), .update(let id, _):
      url.path = "/movies/\(id)"
    case .findAll, .register:
      url.path = "/movies"
    }

    return try! url.asURL()
  }

  var httpBody: Data? {
    switch self {
    case .register(let requestEntity as Encodable),
         .update(_, let requestEntity as Encodable):
      return try! jsonEncoder.encode(requestEntity)
    default:
      return nil
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

  class func register(requestEntity: MovieRegisterRequest, completion:  @escaping (Result<Movie, AFError>) -> Void) {
    AF.request(MovieEnpoints.register(requestEntity: requestEntity)).responseDecodable(of: Movie.self) { response in
      completion(response.result)
    }
  }

  class func update(id: String, requestEntity: MovieUpdateRequest, completion: @escaping (Result<Data?, AFError>) -> Void) {
    AF.request(MovieEnpoints.update(id: id, requestEntity: requestEntity)).response { response in
      completion(response.result)
    }
  }
}
