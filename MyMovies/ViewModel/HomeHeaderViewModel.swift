//
//  HomeHeaderViewModel.swift
//  iMovie
//
//  Created by Herculano Leo de Oliveira Dias on 05/08/23.
//

import Foundation
import RxSwift

class HomeHeaderViewModel {

  private let userPublish = PublishSubject<ObservableErrorWrapper<User>>()

  var user: Observable<ObservableErrorWrapper<User>> {
    get {
      return userPublish.asObserver()
    }
  }

  var greetings: String {
    get {
      let calendar = Calendar.current
      let components = calendar.dateComponents([.hour], from: Date())
      if let hour = components.hour {
        if hour > 6 && hour < 12 {
          return "Good morning!"
        } else if hour > 12 && hour < 18 {
          return "Good afternoon!"
        } else {
          return "Good evening!"
        }
      } else {
        return "Welcome!"
      }
    }
  }


  func fetchUser(_ userId: String) {
    UserApiResoruce.findById(userId) {[weak self] result in
      switch result {
      case .success(let user):
        self?.userPublish.onNext(.success(user))
      case .failure(let error):
        self?.userPublish.onNext(.error(error))
      }
    }
  }
}
