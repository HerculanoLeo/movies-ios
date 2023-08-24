//
//  EnvironmentsVariables.swift
//  MyMovies
//
//  Created by Herculano Leo de Oliveira Dias on 11/08/23.
//

import Foundation

class EnvironmentsVariables {
  static let shared = EnvironmentsVariables()

  let environment: Environments

  private let config: [String: Any]

  var baseUrl: URLComponents {
    get {
      guard let urlString = config["BASE_URL"] as? String else { fatalError("BASE_URL not found") }
      guard let url = URL(string: urlString) else { fatalError("BASE_URL is invalid") }
      guard let baseUrl = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        fatalError("Error to generate URLComponents")
      }
      return baseUrl
    }
  }

  init() {
    guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String else {
      fatalError("Configuration not found in info.plist")
    }
    self.environment = Environments(rawValue: currentConfiguration)!

    switch self.environment{
    case .debug, .release, .debugLocal, .releaseLocal:
      guard let path = Bundle.main.path(forResource: "Config-Local", ofType: "plist") else { fatalError("Config file not found for \(environment)") }
      guard let config = NSDictionary(contentsOfFile: path) as? [String: Any] else { fatalError("Error to unwrap Config for \(environment)") }
      self.config = config
      break
    case .debugDev, .releaseDev:
      guard let path = Bundle.main.path(forResource: "Config-Dev", ofType: "plist") else { fatalError("Config file not found for \(environment)") }
      guard let config = NSDictionary(contentsOfFile: path) as? [String: Any] else { fatalError("Error to unwrap Config for \(environment)") }
      self.config = config
      break
    }
  }

}
