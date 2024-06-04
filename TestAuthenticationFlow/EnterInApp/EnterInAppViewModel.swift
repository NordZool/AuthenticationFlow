import Foundation

class EnterInAppViewModel : ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isValidNumber: Bool = false
    
    @Published var isErrorOccure: Bool = false
    
    private let networkService = SMSNetworkService()
    
    func checkValidityOf(_ number:String, forLogin:Bool) {
        isLoading = true
        if forLogin {
            networkService.sendCheckLoginRequest(for: number) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    switch result {
                    case .success(let success):
                        self?.isValidNumber = success
                    case .failure:
                        self?.isErrorOccure = true
                    }
                }
            }
        } else {
            networkService.sendCheckRegistrationRequest(for: number) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    switch result {
                    case .success(let success):
                        self?.isValidNumber = success
                    case .failure:
                        self?.isErrorOccure = true
                    }
                }
            }
        }
    }
    
    func matchSMSpin(with pin: String) {
        //cancel in authorizeUser()
        isLoading = true
        
        networkService.matchSMSpin(with: pin) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    //логиним пользователя
                    self?.authorizeUser()
                case .failure:
                    self?.isErrorOccure = true
                }
            }
        }
    }
    
    private func authorizeUser() {
        let token = UUID().uuidString
        
        networkService.authorizeUser(with: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let success):
                    UserDefaults.standard.set(token, forKey: "token")
                    AppManager.Authenticated.send(success)
                case .failure:
                    //handle error
                    //...
                    //not auhorize
                    AppManager.Authenticated.send(false)
                }
            }
        }
        
    }
}
