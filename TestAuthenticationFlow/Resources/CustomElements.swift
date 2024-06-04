//
//  CustomElements.swift
//  TestAuthenticationFlow
//
//  Created by admin on 2.06.24.
//

import SwiftUI
import Combine

//MARK: VIEWMODIFIERS
struct OtpModifier: ViewModifier {
    
    @Binding var pin : String
    
    var textLimit = 1

    func limitText(_ upper : Int) {
        if pin.count > upper {
            DispatchQueue.main.async {
                self.pin = String(pin.suffix(upper))
            }
        }
    }
    
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimit)}
    }
}

struct CustomButtonModifier : ViewModifier {
    let disable: Bool
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .frame(width: 350,height: 55)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(disable ? AnyShapeStyle(.gray) : AnyShapeStyle(AppearancesResources.frameGradient))
                    .disabled(disable)
            )
            .contentShape(RoundedRectangle(cornerRadius: 30))
            
            
    }
}

struct CustomBorderModifier : ViewModifier {
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding(10)
            .padding(.vertical,3)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 1)
                    .fill(AppearancesResources.frameGradient)
            }
            .padding(0.5)
    }
}

extension View {
    func setCustomBorder(cornerRadius: CGFloat) -> some View {
        self.modifier(CustomBorderModifier(cornerRadius: cornerRadius))
    }
    func setCustomButton(disable:Bool = false) -> some View {
        self.modifier(CustomButtonModifier(disable:disable))
    }
    
    func setPinTextField(pin: Binding<String>) -> some View {
        self.modifier(OtpModifier(pin: pin))
    }
}


//MARK: VIEWS


struct BackButton : View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss.callAsFunction()
        } label: {
            Image(systemName: "arrow.left")
                .foregroundStyle(.white)
        }
    }
}

struct CustomProgressView : View {
    var body: some View {
        ZStack {
            Rectangle().fill(.black.opacity(0.4))
                .ignoresSafeArea(.all)
            ProgressView()
                .progressViewStyle(.circular)
                .tint(AppearancesResources.frameGradient)
                .scaleEffect(3)
        }
    }
}

#Preview {
    CustomProgressView()
}
