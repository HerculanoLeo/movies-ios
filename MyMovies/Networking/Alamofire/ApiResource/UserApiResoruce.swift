//
//  UserApiResoruce.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 26/08/23.
//

import Foundation

class UserApiResoruce {
  class func findById(_ id: String, completion: @escaping (Result<User, Error>) -> Void) {
    API.shared.main.get("/users/\(id)", of: User.self ,completion: completion)
  }
}
