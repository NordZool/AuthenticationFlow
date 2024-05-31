//
//  EnterInAppView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct EnterInAppView: View {
    //otherwise - is registring
    let isLogin: Bool
    private let mainLabel: String
    
    init(isLogin: Bool) {
        if isLogin {
            mainLabel = "Войти"
        } else {
            mainLabel = "Зарегистрироваться"
        }
        
        self.isLogin = isLogin
    }
    
    var body: some View {
        Text("Test")
        
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(mainLabel)
                        .foregroundStyle(.white)
                        .font(.title2)
                }
            }
        
    }
}

#Preview {
    NavigationStack {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
            
            EnterInAppView(isLogin: true)
        }
    }
}
