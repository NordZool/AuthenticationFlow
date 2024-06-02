//
//  CustomElements.swift
//  TestAuthenticationFlow
//
//  Created by admin on 2.06.24.
//

import SwiftUI

//struct CustomButton : View {
//    let labelText: String
//    let action: () -> ()
//    let isNavigationLink: Bool = false
//    
//    var body: some View {
//        Button(action: action) {
//            
//            Text(labelText)
//            .foregroundStyle(.white)
//            .frame(width: 350,height: 60)
//            .background(
//                RoundedRectangle(cornerRadius: 30)
//                    .fill( AppearancesResources.frameGradient)
//            )
//        }
//    }
//}

struct CustomButtonModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .frame(width: 350,height: 60)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill( AppearancesResources.frameGradient)
            )
    }
}

struct CustomBorderModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .padding(.vertical,3)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .fill(AppearancesResources.frameGradient)
            }
            .padding(0.5)
    }
}

extension View {
    func setCustomBorder() -> some View{
        self.modifier(CustomBorderModifier())
    }
    
    func setCustomButton() -> some View {
        self.modifier(CustomButtonModifier())
    }
}
