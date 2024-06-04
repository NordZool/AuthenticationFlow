//
//  File.swift
//  TestAuthenticationFlow
//
//  Created by admin on 4.06.24.
//

import Foundation

class PincodeViewModel : ObservableObject {
    private let pincodeManager = PincodeManager()
    //only for token send
    private let networkService = SMSNetworkService()
    
    @Published var isPincodeExists: Bool
    @Published var skipPincodeEnter: Bool
    
    init() {
        let isPincodeExists = pincodeManager.isPincodeExists()
        self.isPincodeExists = isPincodeExists
        self.skipPincodeEnter = isPincodeExists
    }
    
    func setPincode(_ pincode:String) -> Bool{
        do {
            let success = try pincodeManager.savePincodeInKeyChain(pincode)
            return success
        } catch {
            print(error)
            return false
        }
    }
    
    func matchPincode(witch pincode:String) -> Bool {
        do {
            return try pincodeManager.matchPincode(with: pincode)
        } catch {
            print(error)
            return false
        }
    }
    
    func deletePincode() {
        let _ = pincodeManager.deletePinCode()
        isPincodeExists = false
        skipPincodeEnter = false
    }
    
    func pincodeAuthorizeUser() {
        let token = UUID().uuidString
        UserDefaults.standard.set(token, forKey: "token")
        AppManager.Authenticated.send(true)
        
        networkService.authorizeUser(with: token) {_ in
        }
    }
}
