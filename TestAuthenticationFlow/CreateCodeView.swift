//
//  CreateCodeView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 3.06.24.
//

import SwiftUI

struct CreateCodeView: View {
    @State private var codeText: String = ""
    @FocusState private var codeTextFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppearancesResources.backgroundColor
                    .ignoresSafeArea(.all)
                    .zIndex(-1)
                VStack {
                    Text("Создайте код приложения")
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding(.bottom, 45)
                        .padding(.top,20)
                    Text("Введите код из символов")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 25)
                    CodeTextField(codeText: $codeText, codeTextFocused: $codeTextFocused)
                        .padding(.bottom,80)
                    if codeText.isEmpty {
                        Button("Пропустить") {
                            
                        }
                        .setCustomButton()
                    }
                    Spacer()
                        .frame(maxHeight: 450)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Код приложения")
                        .foregroundStyle(.white)
                        .font(.title2)
                }
            }
        }
    }
}

struct CodeTextField : View {
    @Binding var codeText: String
    var codeTextFocused: FocusState<Bool>.Binding
    
    
    
    var body: some View {
        ZStack {
            HStack(spacing:30) {
                ForEach(0..<4) {index in
                    OTPBox(index)
                }
            }
            .frame(width: 160,height: 30)
            .padding(10)
            .padding(.vertical,3)
            .overlay {
                if codeTextFocused.wrappedValue {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(lineWidth: 1)
                        .fill(AppearancesResources.frameGradient)
                }
            }
            .background(RoundedRectangle(cornerRadius: 30).fill(.gray).opacity(0.1))
            .onTapGesture {
                codeTextFocused.wrappedValue.toggle()
            }
            
            SecureField("", text: $codeText.limit(4))
                .focused(codeTextFocused)
                .frame(width: 1, height: 1)
                .opacity(0.001)
                .blendMode(.screen)
                .keyboardType(.numberPad)
        }
    }
    
    @ViewBuilder func OTPBox(_ index: Int) -> some View {
        Circle()
            .frame(width: 10)
        //if ">" -> that Box is filled
            .foregroundStyle(codeText.count > index
                             ? AnyShapeStyle(AppearancesResources.frameGradient) : AnyShapeStyle(.gray))
    }
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if self.wrappedValue.count > length {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(length))
            }
        }
        
        return self
    }
}

#Preview {
    CreateCodeView()
}
