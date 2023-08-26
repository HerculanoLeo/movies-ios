//
//  MovieRegisterRequest.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 14/08/23.
//

import Foundation

struct MovieRegisterRequest: Encodable {
  enum Error: FormFieldError {
    case name
    case synopsys
    case ageGroup
    case stars
    case movieCoverUrl
    case movieWallpaperUrl
  }

  var name: String
  var synopsys: String?
  var ageGroup: String
  var stars: Int = 0
  var movieCoverUrl: String?
  var movieWallpaperUrl: String?
}
