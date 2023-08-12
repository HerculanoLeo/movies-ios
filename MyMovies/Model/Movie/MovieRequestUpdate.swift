//
//  MovieRequestUpdate.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 12/08/23.
//

import Foundation

struct MovieRequestUpdate: Encodable {
  var id: String
  var name: String
  var synopsis: String
  var ageGroup: String
  var stars: Int
  var movieCoverUrl: String;
  var movieWallpaperUrl: String;
}
