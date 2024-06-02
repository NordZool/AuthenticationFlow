//
//  ContentView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
//            MainView(isPincodeExist: false)
            EnterInAppView(isLogin: false)
        }
        .onAppear(perform: {
            print(CountryData.countries.count)
        })
    }
}

#Preview {
    ContentView()
}
