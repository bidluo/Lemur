import Foundation

public protocol UserDefaultsType {
    func setValue(_: Any?, forKey: String)
    func stringArray(forKey: String) -> [String]?
}

extension UserDefaults: UserDefaultsType {
    
}
