//
//  CreateCodeView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 3.06.24.
//

import SwiftUI

struct PincodeView: View {
    @ObservedObject var pincodeViewModel: PincodeViewModel
    @State private var isSuccessInputPincode = false
    @State private var isFailInputPincode = false
    @State private var failShakeAnimation = false
    
    @State private var codeText: String = ""
    @FocusState private var codeTextFocused: Bool
    //otherwise - is a login with pin
    let isCreatePin: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppearancesResources.backgroundColor
                    .ignoresSafeArea(.all)
                    .zIndex(-1)
                VStack {
                    if isCreatePin {
                        Text("Создайте код приложения")
                            .foregroundStyle(.white)
                            .font(.title)
                            .padding(.bottom, 45)
                            .padding(.top,160)
                    }
                    Text("Введите код из символов")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .padding(.bottom, 25)
                    VStack(spacing:0) {
                        CodeTextField(codeText: $codeText, codeTextFocused: $codeTextFocused)
                            .offset(x:failShakeAnimation ? 30 : 0)
                            .padding(.bottom, 10)
                            if isFailInputPincode {
                                Text("Вы ввели неверный код")
                                    .foregroundStyle(.red)
                                    .font(.footnote)
                            } else {
                                Text("Вы ввели неверный код")
                                    .foregroundStyle(.red)
                                    .font(.footnote)
                                    .opacity(0.001)
                            }
                       
                    }
                    .frame(height: 70)
                    .padding(.bottom, 50)
                    
                        
                    
                    
                    
                    if codeText.isEmpty && isCreatePin {
                        Button("Пропустить") {
                            pincodeViewModel.skipPincodeEnter = true
                        }
                        .setCustomButton()
                    }
                    
                    Spacer()
                        .frame(maxHeight: 450)
                }
                //alert
                if isSuccessInputPincode {
                    Rectangle().fill(.black).opacity(0.5).ignoresSafeArea(.all)
                    VStack(spacing: 30) {
                        Text("""
            Вы успешно \(isCreatePin ? "создали" : "ввели") код
            приложения
            """)
                            
                        .frame(width: 350, height: 100)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.alertBackground))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        
                        Button("Войти в приложение") {
                            if isCreatePin {
                                pincodeViewModel.isPincodeExists = true
                            } else {
                                pincodeViewModel.pincodeAuthorizeUser()
                            }
                        }
                        .frame(width: 350, height: 70)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.alertBackground))
                    }
                }
            }
            .ignoresSafeArea(.all)
            .onChange(of: codeText, { _, _ in
                if codeText.count == 4 {
                        if isCreatePin {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                isSuccessInputPincode = pincodeViewModel.setPincode(codeText)
                            }
                            
                            codeTextFocused = false
                        } else {
                            if pincodeViewModel.matchPincode(witch: codeText) {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    isSuccessInputPincode = true
                                }
                                
                                codeTextFocused = false
                            } else {
                                failShakeAnimation = true
                                withAnimation(Animation.spring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)) {
                                    failShakeAnimation = false
                                }
                                isFailInputPincode = true
                                codeText = ""
                            }
                        }
                } else if !codeText.isEmpty {
                    isFailInputPincode = false
                }
            })
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
    ZStack {
        AppearancesResources.backgroundColor.ignoresSafeArea(.all)
         
        PincodeView(pincodeViewModel: .init(), isCreatePin: false)
    }
}
