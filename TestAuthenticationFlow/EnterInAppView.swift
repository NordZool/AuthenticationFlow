//
//  EnterInAppView.swift
//  TestAuthenticationFlow
//
//  Created by admin on 31.05.24.
//

import SwiftUI

struct EnterInAppView: View {
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
            VStack {
                if isSuccessSendCode {
                    VereficationView(buttonLabel: mainLabel)
                        .transition(AnyTransition.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .trailing)))
                        .padding(.top, 20)
                    
                    
                }
                if !isSuccessSendCode {
                    SendNumberCodeView(isSuccess: $isSuccessSendCode)
                        .transition(AnyTransition.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .leading)))
                }
                Spacer()
                    .frame(maxHeight: 450)
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
              BackButton()
            }
        }
        
        
    }
    
    
}


// MARK: Verefication VIEW
struct VereficationView : View {
    @State private var pincode: String = ""
    let buttonLabel: String
    //timer
    @State private var timeRemaining = 300
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showAnotherSendButton = false

    var body: some View {
        VStack {
            Text("Верефикация")
                .foregroundStyle(.white)
                .font(.title)
                .padding(.bottom,-8)
            
            Text("""
                Введите код из смс,
                что мы вам отправили
                """
            )
            .foregroundStyle(.gray)
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .frame(height: 80)
            
            Group {
                if showAnotherSendButton {
                    Button {
                        showAnotherSendButton = false
                    } label: {
                        VStack(spacing:0) {
                            Text("Отправить код еще раз")
                            Rectangle()
                                .frame(height: 1)
                        }
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundStyle(.blue)
                    }
                    
                } else {
                    Text("""
                 Запросить код можно через
                 через \(timeInMinutesFormat(timeRemaining))
                 """)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .onReceive(timer) {_ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            showAnotherSendButton = true
                        }
                    }
                }
            }
            .frame(height: 80)
            .padding(.bottom,8)
     
            SMSPinTextField(pincode: $pincode)
                .padding(.bottom, 23)
                .foregroundStyle(.white)
                .font(.title2)
            
            Button(buttonLabel) {
                //
            }
            .setCustomButton(disable: pincode.count != 6)
            .padding(.bottom, 20)
            
            Button {
                //
            } label: {
                VStack(spacing:0) {
                    Text("Я не получил код!")
                    Rectangle()
                        .frame(height: 1)
                }
                .foregroundStyle(.white)
                .fixedSize(horizontal: true, vertical: false)
                .font(.footnote)
            }

           
        }
    }
    
    private func timeInMinutesFormat(_ secounds:Int) -> String {
        let minuts = secounds / 60
        let remainSecounds = secounds % 60
        
        var minutsString = String(minuts)
        if minuts / 10 == 0 {
            minutsString = "0" + minutsString
        }
        var secoundsString = String(remainSecounds)
        if remainSecounds / 10 == 0 {
            secoundsString = "0" + secoundsString
        }
        
        return "\(minutsString):\(secoundsString)"
    }
}

struct SMSPinTextField : View {
    @Binding var pincode: String
    
    enum FocusPin : CaseIterable {
        case pinOne, pinTwo, pinThree, pinFour, pinFive, pinSix
        
        func next() -> FocusPin? {
            switch self {
            case .pinOne:
                    .pinTwo
            case .pinTwo:
                    .pinThree
            case .pinThree:
                    .pinFour
            case .pinFour:
                    .pinFive
            case .pinFive:
                    .pinSix
            case .pinSix:
                nil
            }
        }
        
        func back() -> FocusPin? {
            switch self {
            case .pinOne:
                nil
            case .pinTwo:
                    .pinOne
            case .pinThree:
                    .pinTwo
            case .pinFour:
                    .pinThree
            case .pinFive:
                    .pinFour
            case .pinSix:
                    .pinFive
            }
        }
    }
    
    @FocusState private var focusPin: FocusPin?
    @State private var pinOne: String = ""
    @State private var pinTwo: String = ""
    @State private var pinThree: String = ""
    @State private var pinFour: String = ""
    @State private var pinFive: String = ""
    @State private var pinSix: String = ""
    
    private var resultPin : String {
        pinOne + pinTwo + pinThree + pinFour + pinFive + pinSix
    }
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(FocusPin.allCases, id:\.self) {pin in
                TextField("", text: bindingPin(for: pin))
                    .setPinTextField(pin: bindingPin(for: pin))
                    .padding(.vertical, -3.5)
                    .setCustomBorder(cornerRadius: 3)
                //on change string pin
                    .modifier(OnChangePinModifier(pin: bindingPin(for: pin), perform: { _, newValue in
                        if newValue.count == 1 {
                            //if is lasta pin -> unfocus user
                            focusPin = pin.next()
                        }
                        if newValue.count == 0, let back = pin.back() {
                            focusPin = back
                        }
                        
                        pincode = resultPin
                    }))
                    .focused($focusPin, equals: pin)
            }
            
            Spacer()
        }
        .padding(.horizontal,20)
        .onTapGesture {
            if resultPin.isEmpty {
                focusPin = .pinOne
            }
        }
        
    }
    
    func bindingPin(for pin: FocusPin) -> Binding<String> {
        switch pin {
        case .pinOne:
            $pinOne
        case .pinTwo:
            $pinTwo
        case .pinThree:
            $pinThree
        case .pinFour:
            $pinFour
        case .pinFive:
            $pinFive
        case .pinSix:
            $pinSix
        }
    }
    
    private struct OnChangePinModifier : ViewModifier {
        @Binding var pin: String
        let perform: (_ oldValue:String,_ newValue:String) -> ()
        
        func body(content: Content) -> some View {
            content
                .onChange(of: pin) { oldValue, newValue in
                    perform(oldValue, newValue)
                }
            
            
        }
    }
}

struct NoSendCodeView : View {

    var body: some View {
        ZStack {
            AppearancesResources.backgroundColor
                .ignoresSafeArea(.all)
            
            VStack {
                Text("Не пришел код?")
                    .foregroundStyle(.white)
                    .font(.title)
                    .padding(.bottom, 25)
                Text("""
                     Обратитесь в чат
                     поддержки
                     """)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .padding(.bottom, 180)
                
                Button("Перейти в чат поддержки") {
                    //no functional yet
                }
                .setCustomButton()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
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
                .foregroundStyle(.white)
            HStack {
                NumberPicker(selectedCountryID: $selectedCountryID,
                             numberLimit: $numberTextLimit,
                             numberText: $numberText)
                .padding(.trailing, 10)
                TextField("", text: $numberText)
                    .setCustomBorder(cornerRadius: 8)
                    .keyboardType(.numberPad)
                    .onChange(of: numberText) { _, newValue in
                        if newValue.count > numberTextLimit {
                            DispatchQueue.main.async {
                                numberText = String(newValue.prefix(numberTextLimit))
                            }
                        }
                    }
                    .foregroundStyle(.white)
            }
            .padding(.bottom, 15)
            
            VStack {
                
                Text("Код придет на ваш номер телефона")
                    .font(.footnote)
                    .padding(.bottom, 50)
                    .foregroundStyle(.white)
                Button("Получить код") {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        isSuccess = true
                    }
                }
                .setCustomButton()
            }
            
            
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
            .setCustomBorder(cornerRadius: 8)
        }
        .onChange(of: selectedCountryID, { oldValue, newValue in
            if newValue != oldValue {
                numberLimit = CountryData.findCountryNumberLimit(newValue) ?? 0
                numberText = ""
            }
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
        ZStack {
//            AppearancesResources.backgroundColor
//                .ignoresSafeArea(.all)
            NoSendCodeView()
        }
//        EnterInAppView(isLogin: true)
    }
}
