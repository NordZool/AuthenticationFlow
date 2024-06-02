//
//  EnterInAppView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct EnterInAppView: View {
    @Environment(\.dismiss) var dismiss
    
    //otherwise - is registring
    let isLogin: Bool
    private let mainLabel: String

    //вместо state будет паблишер в VM, который скажет - успешно ли отправлен код или нет
    @State private var isSuccessSendCode = false
    
    init(isLogin: Bool) {
        if isLogin {
            mainLabel = "Войти"
        } else {
            mainLabel = "Зарегистрироваться"
        }
        self.isLogin = isLogin
    }
    
    var body: some View {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
                .zIndex(-1)
            
            if isSuccessSendCode {
                VereficationView()
                    .transition(AnyTransition.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)))
               
                
            }
            if !isSuccessSendCode {
                SendNumberCodeView(isSuccess: $isSuccessSendCode)
                    .transition(AnyTransition.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)))
            }
        }
        //for not changing color of toolbar in scroll
        .toolbarBackground(AppearancesResources.backgroundColor, for: .navigationBar)
        .toolbarBackground(.automatic, for: .navigationBar)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(mainLabel)
                    .foregroundStyle(.white)
                    .font(.title2)
            }
            ToolbarItem(placement:.topBarLeading) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundStyle(.white)
                }
            }
    }
        
        
    }
    
    
}


// MARK: Verefication VIEW
struct VereficationView : View {
    var body: some View {
        Text("Верефикация")
            .foregroundStyle(.white)
            .font(.title)
    }
}



// MARK: SendNumberCode VIEW
struct SendNumberCodeView : View {
    @State private var selectedCountryID = "0182"
    @State private var numberTextLimit = 10
    @State private var numberText = ""
    
    @Binding var isSuccess: Bool
    
    var body: some View {
        VStack(alignment:.leading) {
            Text("Номер телефона")
                .font(.footnote)
                .padding(.bottom, 5)
            HStack {
                NumberPicker(selectedCountryID: $selectedCountryID,
                             numberLimit: $numberTextLimit,
                             numberText: $numberText)
                .padding(.trailing, 10)
                TextField("", text: $numberText)
                    .setCustomBorder()
                    .keyboardType(.numberPad)
                    .onChange(of: numberText) { oldValue, newValue in
                        let newCount = newValue.count
                        if newCount > numberTextLimit {
                            numberText = String(newValue.dropLast(newCount-numberTextLimit))
                        }
                    }
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 15)
            
            VStack {
                
                Text("Код придет на ваш номер телефона")
                    .font(.footnote)
                    .padding(.bottom, 50)
                Button("Получить код") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isSuccess = true
                    }
                }
                .setCustomButton()
            }
            
            Spacer()
        }
        
        .frame(width: 350)
    }
}


// MARK: NumberPicker VIEW
struct NumberPicker : View {
    @Binding var selectedCountryID: String
    @Binding var numberLimit:Int
    @Binding var numberText:String
    
    private func pickerRow(_ country: CountryData) -> String {
        country.flag + " " + country.name + " (" + country.dial_code + ")"
    }
    
    var body: some View {
        Menu {
            Picker(selectedCountryID, selection:$selectedCountryID) {
                ForEach(CountryData.countries) {country in
                    Text(pickerRow(country))
                        .tag(country.id)
                }
                
            }
            
        } label: {
            HStack {
                Text(CountryData.findCountryDialcode(selectedCountryID) ?? "error")
                Image(systemName: "chevron.down")
            }
            .foregroundStyle(.white)
            .setCustomBorder()
        }
        .onChange(of: selectedCountryID, { _, newValue in
            numberLimit = CountryData.findCountryNumberLimit(newValue) ?? 0
            numberText = ""
        })
        .preferredColorScheme(.dark)
    }
}

struct CountryData: Codable, Identifiable {
    let id: String
    let name: String
    let flag: String
    let dial_code: String
    let pattern: String
    
    static let countries: [CountryData] = Bundle.main.decode("CountryNumbers.json")
    static func findCountryDialcode(_ id:String) -> String? {
        countries.first(where: {$0.id == id})?
            .dial_code
    }
    static func findCountryNumberLimit(_ id:String) -> Int? {
        countries.first(where: {$0.id == id})?
            .pattern.filter({$0 == "#"}).count
    }
}

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        
        return loaded
    }
}

#Preview {
    NavigationStack {
            
            EnterInAppView(isLogin: true)
    }
}
