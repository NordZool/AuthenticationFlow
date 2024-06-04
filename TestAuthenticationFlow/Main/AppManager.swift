//
//  AppManager.swift
//  TestAuthenticationFlow
//
//  Created by admin on 4.06.24.
//

import Foundation
import Combine

struct AppManager {
    static let Authenticated = PassthroughSubject<Bool, Never>()
    static func IsAuthenticated() -> Bool {
        return UserDefaults.standard.string(forKey: "token") != nil
    }
    static func logout() {
        UserDefaults.standard.set(nil, forKey: "token")
        Authenticated.send(false)
    }
}
