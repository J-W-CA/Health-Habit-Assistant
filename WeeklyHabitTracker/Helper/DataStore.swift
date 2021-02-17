import Foundation

class DataStore {
    
    static let shared  = DataStore()
    
    
    private init(){}
    
    
    func setUserStatus(isExistingUser: Bool) {
        UserDefaults.standard.setValue(isExistingUser, forKey: "user-status")
    }
    
     
    func getUserStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: "user-status")
    }
}
