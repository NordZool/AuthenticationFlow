//
//  AppearancesResources.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

//singleton
struct AppearancesResources {
    private init() {}
    
    static let backgroundColor = Color("backgroundColor")
    static let frameGradient = LinearGradient(
        colors: [Color("firstFrameGradientColor"),
                 Color("secondFrameGradientColor")],
        startPoint: UnitPoint(x: 0.49, y: 1),
        endPoint: UnitPoint(x: 0.53, y: 0)
    )
    
}


#Preview {
    ZStack {
        AppearancesResources.backgroundColor
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppearancesResources.frameGradient)
                .frame(width: 400,height: 100)
            
            Text("Test")
                .padding(10)
                .padding(.vertical,3)
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 4)
                        .fill(AppearancesResources.frameGradient)
                }
                .padding(0.5)
        }
    }
}
