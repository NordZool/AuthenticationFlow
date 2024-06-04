//
//  AuthenticatedUserView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct AuthenticatedUserView: View {
    @ObservedObject var pincodeViewModel: PincodeViewModel
    
    var body: some View {
        ZStack(alignment:.top) {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
            VStack {
                AppLogoImage()
                
                Text("Вы авторизованы!")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.top,50)
                    .padding(.bottom, 80)
                Button {
                    AppManager.logout()
                } label: {
                    VStack(spacing:0) {
                        Text("Выйти из приложения")
                        Rectangle()
                            .frame(height: 1)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundStyle(.white)
                }
                .padding(.bottom, 20)
                if pincodeViewModel.isPincodeExists {
                    Button {
                        pincodeViewModel.deletePincode()
                    } label: {
                        VStack(spacing:0) {
                            Text("Удалить пин-код")
                            Rectangle()
                                .frame(height: 1)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundStyle(.white)
                    }
                }
                
                
                
            }
    
            
        }
    }
}

#Preview {
    AuthenticatedUserView(pincodeViewModel: .init())
}
