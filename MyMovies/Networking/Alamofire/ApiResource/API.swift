//
//  API.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 25/08/23.
//

import Foundation

class API {
  static let shared = API()

  let main = NetworkingManager(baseUrl: EnvironmentsVariables.shared.baseUrl)
  
}
