//
//  MovieApiResource.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation

class MovieApiResource {
  class func findAll(completion: @escaping (Result<[Movie], Error>) -> Void) {
    API.shared.main.get("/movies", of: [Movie].self, completion: completion)
  }

  class func findById(id: String, completion: @escaping (Result<Movie, Error>) -> Void) {
    API.shared.main.get("/movies/\(id)", of: Movie.self, completion: completion)
  }

  class func register(requestEntity: MovieRegisterRequest, completion: @escaping (Result<Movie, Error>) -> Void) {
    API.shared.main.post("/movies", requestEntity, of: Movie.self, completion: completion)
  }

  class func update(id: String, requestEntity: MovieUpdateRequest, completion: @escaping (Result<Data?, Error>) -> Void) {
    API.shared.main.put("/movies/\(id)", requestEntity, completion: completion)
  }
}
