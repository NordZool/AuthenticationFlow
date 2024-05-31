//
//  MainView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct MainView: View {
    private let logButtonLabel: String
    private let isPincodeEnter: Bool
    
    init(isPincodeExist: Bool) {
        if isPincodeExist {
            logButtonLabel = "Войти по коду приложения"
        } else {
            logButtonLabel = "Войти по номеру телефона"
        }
        self.isPincodeEnter = isPincodeExist
    }
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            
            VStack(spacing: 20) {
                AppLogoImage()
                    .padding(.bottom, -10)
                
                Text("SIS")
                    .foregroundStyle(.white)
                    .font(.title)
                    .fontWeight(.bold)
                Text("Выбери свою безопасность")
                    .foregroundStyle(.white)
                    .font(.title3)
            }
            .padding(.bottom,100)
            
            Button {
                if isPincodeEnter {
                    //go to pincode view
                } else {
                    //go to login view
                }
            } label: {
                    Text(logButtonLabel)
                        .foregroundStyle(.white)
                        .frame(width: 350,height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill( AppearancesResources.frameGradient)
                        )
            }
            .padding(.bottom,100)
            
            
                Text("У вас нет аккаунта?")
                    .foregroundStyle(.white)
                Button {
                    
                } label: {
                    VStack(spacing:0) {
                        Text("Зарегистрируйтесь сейчас")
                        Rectangle()
                            .frame(height: 1)
                        
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
            
            
            Spacer()
        }
            
    }
}

struct AppLogoImage : View {
    var body: some View {
        Image("appLogo")
            .scaleEffect(0.7)
    }
}

#Preview {
    ZStack {
        AppearancesResources.backgroundColor
            .ignoresSafeArea(.all)
        MainView(isPincodeExist: false)
    }
}
