//
//  NetworkingManager+Extensions.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation

extension NetworkingManager {
  func get<T: Decodable>(_ path: String, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .get, path, nil, nil, of: of, completion: completion)
  }

  func get<T: Decodable>(_ path: String, of: T.Type, _ options: NetworkingOptions, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .get, path, nil, options, of: of, completion: completion)
  }

  func post<T: Decodable>(_ path: String, _ requestEntity: Encodable?, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .post, path, requestEntity, nil, of: of, completion: completion)
  }

  func post<T: Decodable>(_ path: String, _ requestEntity: Encodable?, of: T.Type, _ options: NetworkingOptions, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .post, path, requestEntity, options, of: of, completion: completion)
  }

  func put<T: Decodable>(_ path: String, _ requestEntity: Encodable?, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .put, path, requestEntity, nil, of: of, completion: completion)
  }

  func put<T: Decodable>(_ path: String, _ requestEntity: Encodable?, of: T.Type, _ options: NetworkingOptions, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .put, path, requestEntity, options, of: of, completion: completion)
  }

  func delete<T: Decodable>(_ path: String, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .delete, path, nil, nil, of: of, completion: completion)
  }

  func delete<T: Decodable>(_ path: String, of: T.Type, _ options: NetworkingOptions, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .delete, path, nil, options, of: of, completion: completion)
  }

  func delete<T: Decodable>(_ path: String, _ requestEntity: Encodable?, of: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .delete, path, requestEntity, nil, of: of, completion: completion)
  }

  func delete<T: Decodable>(_ path: String, _ requestEntity: Encodable?, of: T.Type, _ options: NetworkingOptions, completion: @escaping (Result<T, Error>) -> Void) {
    request(httpMethod: .delete, path, requestEntity, options, of: of, completion: completion)
  }
}

extension NetworkingManager {
  func get(_ path: String, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .get, path, nil, nil, completion: completion)
  }

  func get(_ path: String, _ options: NetworkingOptions, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .get, path, nil, options, completion: completion)
  }

  func post(_ path: String, _ requestEntity: Encodable?, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .post, path, requestEntity, nil, completion: completion)
  }

  func post(_ path: String, _ requestEntity: Encodable?, _ options: NetworkingOptions, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .post, path, requestEntity, options, completion: completion)
  }

  func put(_ path: String, _ requestEntity: Encodable?, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .put, path, requestEntity, nil, completion: completion)
  }

  func put(_ path: String, _ requestEntity: Encodable?, _ options: NetworkingOptions, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .put, path, requestEntity, options, completion: completion)
  }

  func delete(_ path: String, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .delete, path, nil, nil, completion: completion)
  }

  func delete(_ path: String, _ options: NetworkingOptions, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .delete, path, nil, options, completion: completion)
  }

  func delete(_ path: String, _ requestEntity: Encodable?, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .delete, path, requestEntity, nil, completion: completion)
  }

  func delete(_ path: String, _ requestEntity: Encodable?, _ options: NetworkingOptions, completion: @escaping (Result<Data?, Error>) -> Void) {
    request(httpMethod: .delete, path, requestEntity, options, completion: completion)
  }
}
