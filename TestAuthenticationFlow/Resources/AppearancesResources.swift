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
        startPoint: UnitPoint(x: 0.5, y: 1),
        endPoint: UnitPoint(x: 0.6, y: 0)
    )
    
}


#Preview {
    RoundedRectangle(cornerRadius: 30)
        .fill(AppearancesResources.frameGradient)
        .frame(width: 350,height: 100)
}
