//
//  MainView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct MainView: View {
    //if user already has pin
    @ObservedObject var pincodeViewModel: PincodeViewModel
    
    private let logButtonLabel: String
    private let isPincodeEnter: Bool
    
    init(isPincodeExist: Bool, pincodeViewModel: PincodeViewModel) {
        if isPincodeExist {
            logButtonLabel = "Войти по коду приложения"
        } else {
            logButtonLabel = "Войти по номеру телефона"
        }
        self.isPincodeEnter = isPincodeExist
        self.pincodeViewModel = pincodeViewModel
    }
    
    var body: some View {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
                .zIndex(-1)
            
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
                NavigationLink {
                    if isPincodeEnter {
                        PincodeView(pincodeViewModel: pincodeViewModel, isCreatePin: false)
                            .navigationBarBackButtonHidden()
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    BackButton()
                                }
                            }
                    } else {
                        EnterInAppView(isLogin: true)
                    }
                } label: {
                    Text(logButtonLabel)
                        .setCustomButton()
                }
                
                .padding(.bottom,100)
                
                
                    Text("У вас нет аккаунта?")
                        .foregroundStyle(.white)
                NavigationLink {
                    EnterInAppView(isLogin: false)
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
}

struct AppLogoImage : View {
    var body: some View {
        Image("appLogo")
            .scaleEffect(0.7)
    }
}

#Preview {
    NavigationStack {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
            MainView(isPincodeExist: false, pincodeViewModel: PincodeViewModel())
        }
    }
}
