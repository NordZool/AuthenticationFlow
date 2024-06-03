//
//  ContentView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct ContentView: View {
    @State var test: String  = ""
    var body: some View {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
//            MainView(isPincodeExist: false)
                SMSPinTextField(pincode: $test)
            
        }
    }
}

#Preview {
    ContentView()
}
