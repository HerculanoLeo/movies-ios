//
//  InputOneMenuSelectDelegate.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 09/09/23.
//

import Foundation
import UIKit

protocol InputDropdownDelegate {
  func showOptions(_ optionsView: some UIView)
  func hideOptions()
}
