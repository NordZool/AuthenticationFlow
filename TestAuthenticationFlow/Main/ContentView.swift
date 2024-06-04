//
//  ContentView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct ContentView: View {
    @State var isAuthenticated = AppManager.IsAuthenticated()
    
    @StateObject private var pincodeViewModel = PincodeViewModel()
    var body: some View {
        Group {
            if isAuthenticated {
                ZStack {
                    AuthenticatedUserView(pincodeViewModel: pincodeViewModel)
                    if !pincodeViewModel.skipPincodeEnter && !pincodeViewModel.isPincodeExists{
                        PincodeView(pincodeViewModel: pincodeViewModel, isCreatePin: true)
                    }
                }
                .transition(AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)))
                .padding(.top, 20)
            }
            
            if !isAuthenticated {
                NavigationStack {
                    MainView(isPincodeExist: pincodeViewModel.isPincodeExists, pincodeViewModel: pincodeViewModel)
                }
                .transition(AnyTransition.asymmetric(
                    insertion: .move(edge: .leading),
                    removal: .move(edge: .leading)))
            }
            
        }
        .ignoresSafeArea(.all)
        .onReceive(AppManager.Authenticated, perform: {value in
            withAnimation(.easeInOut(duration: 0.4)) {
                isAuthenticated = value
            }
        })
    }
        
}

#Preview {
    ContentView()
}
