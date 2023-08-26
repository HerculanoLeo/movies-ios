//
//  NetworkingManager.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 24/08/23.
//

import Foundation
import Alamofire

struct NetworkingOptions {
  var headers: [String: String]?
  var params: [String: String]?
}

struct NetworkingRequest: URLRequestConvertible {
  let request: URLRequest

  func asURLRequest() throws -> URLRequest {
    return self.request
  }
}

open class NetworkingManager {

  private(set) var baseUrl: URLComponents

  private let jsonEncoder = JSONEncoder()

  public var defaultHeaders: [String: String] = [:]

  init(baseUrl: URLComponents) {
    self.baseUrl = baseUrl
  }

  func request<T: Decodable>(httpMethod: HTTPMethod, _ path: String, _ requestEntity: Encodable?, _ options: NetworkingOptions?, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    do {
      let request = try requestBuilder(httpMethod: httpMethod, path, requestEntity, options)
      AF.request(request).responseDecodable(of: of) { response in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error as Error))
        }
      }
    } catch {
      completion(.failure(error))
    }
  }

  func request(httpMethod: HTTPMethod, _ path: String, _ requestEntity: Encodable?, _ options: NetworkingOptions?, completion: @escaping (Result<Data?, Error>) -> Void) {
    do {
      let request = try requestBuilder(httpMethod: httpMethod, path, requestEntity, options)
      AF.request(request).response { response in
        switch response.result {
        case .success(let data):
          completion(.success(data))
        case .failure(let error):
          completion(.failure(error as Error))
        }
      }
    } catch {
      completion(.failure(error))
    }
  }

  private func requestBuilder(httpMethod: HTTPMethod, _ path: String, _ requestEntity: Encodable?, _ options: NetworkingOptions?) throws -> NetworkingRequest {
    do {
      var url = self.baseUrl
      url.path = path

      if let params = options?.params {
        var queryItems: [URLQueryItem] = []
        for param in params {
          queryItems.append(URLQueryItem(name: param.key, value: param.value))
        }
        url.queryItems = queryItems
      }

      var request = try URLRequest(url: url, method: httpMethod)
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")

      for header in defaultHeaders {
        request.setValue(header.key, forHTTPHeaderField: header.value)
      }

      if let headers = options?.headers {
        for header in headers {
          request.setValue(header.key, forHTTPHeaderField: header.value)
        }
      }

      if let requestEntity = requestEntity {
        let httpBody = try jsonEncoder.encode(requestEntity)
        request.httpBody = httpBody
      }

      return NetworkingRequest(request: request)
    }catch {
      throw error
    }
  }
}
