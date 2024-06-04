//
//  SMSNetworkService.swift
//  TestAuthenticationFlow
//
//  Created by admin on 4.06.24.
//

import Foundation


class SMSNetworkService {
    
    func sendCheckLoginRequest(for number:String, complitionHandler: @escaping (Result<Bool,Error>) -> Void) {
        //hard code, there could be URLSession
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.3) {
            //checking number
            //...
            //call handler
            complitionHandler(.success(true))
        }
    }
    
    func sendCheckRegistrationRequest(for number:String, complitionHandler: @escaping (Result<Bool,Error>) -> Void) {
        //hard code, there could be URLSession
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.3) {
            //checking number
            //...
            //call handler
            complitionHandler(.success(true))
        }
    }
    
    func matchSMSpin(with pin: String, complitionHandler: @escaping (Result<Bool,Error>) -> Void) {
        //hard code, there could be URLSession
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.3) {
            //checking is pin code is correct
            //...
            //call handler
            complitionHandler(.success(true))
        }
    }
    
    func authorizeUser(with token:String, complitionHandler: @escaping (Result<Bool,Error>) -> Void) {
        //hard code, there could be URLSession
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.3) {
            //checking - can we authorize user or not
            //...
            //call handler
            complitionHandler(.success(true))
        }
    }
}
