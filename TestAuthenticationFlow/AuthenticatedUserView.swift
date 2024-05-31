//
//  AuthenticatedUserView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct AuthenticatedUserView: View {
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
            }
        }
            
    }
}

#Preview {
    AuthenticatedUserView()
}
