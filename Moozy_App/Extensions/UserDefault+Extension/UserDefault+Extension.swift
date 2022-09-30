//
//  UserDefault+Extension.swift
//  Moozy_App
//
//  Created by Ali Abdullah on 25/04/2022.
//

import Foundation

extension UserDefaults {
    static func getSavedValue<T>(key: UserDefaultsKey) -> T {
        let decoded = UserDefaults.standard.object(forKey: key.rawValue) as! Data
        return (NSKeyedUnarchiver.unarchiveObject(with: decoded) as! T)
    }
    
    static func setSavedValue<T>(value: T, key: UserDefaultsKey) {
        let userEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(userEncodedData, forKey: key.rawValue)
    }
    
    static func removeAllKeysValues() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    static func removeSpecificKeysValues(key: UserDefaultsKey) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
    
    static func containsKey(key: UserDefaultsKey) -> Bool {
        return UserDefaults.standard.object(forKey: key.rawValue) != nil
    }
    
    
    //Chatto App Userdefault
    
    static func removeSpecificKeys(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
    static func Get_ChatMessage<T>(key: String) -> T {
        let decoded = UserDefaults.standard.object(forKey: key) as! Data
        return (NSKeyedUnarchiver.unarchiveObject(with: decoded) as! T)
    }
    
    static func Save_ChatMessage<T>(value: T,key: String) {
        let userEncodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        UserDefaults.standard.set(userEncodedData, forKey: key)
    }
    
    static func containsChatKey(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
