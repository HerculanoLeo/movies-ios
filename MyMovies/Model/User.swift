//
//  User.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 06/08/23.
//

import Foundation

struct User {
  let id: String?
  var name: String;
  var profileImageUrl: String?
}

let user: User = User(id: "1", name: "Georde Phoenix", profileImageUrl: "https://photografos.com.br/wp-content/uploads/2020/09/fotografia-para-perfil.jpg")
