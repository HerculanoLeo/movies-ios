//
//  MovieRegisterRequest.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 14/08/23.
//

import Foundation

class MovieRegisterRequest: Codable {
  var name: String
  var synopsys: String?
  var ageGroup: String
  var stars: Int = 0
  var movieCoverUrl: String?
  var movieWallpaperUrl: String?


  enum Error: FormFieldError {
    case name
    case synopsys
    case ageGroup
    case stars
    case movieCoverUrl
    case movieWallpaperUrl
  }

  enum CodingKeys: String, CodingKey {
      case name
      case synopsys
      case ageGroup
      case stars
      case movieCoverUrl
      case movieWallpaperUrl
  }

  init(name: String, ageGroup: String) {
    self.name = name
    self.ageGroup = ageGroup
  }

  required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)

      name = try container.decode(String.self, forKey: .name)
      synopsys = try container.decodeIfPresent(String.self, forKey: .synopsys)
      ageGroup = try container.decode(String.self, forKey: .ageGroup)
      stars = try container.decodeIfPresent(Int.self, forKey: .stars) ?? 0
      movieCoverUrl = try container.decodeIfPresent(String.self, forKey: .movieCoverUrl)
      movieWallpaperUrl = try container.decodeIfPresent(String.self, forKey: .movieWallpaperUrl)
  }
}
