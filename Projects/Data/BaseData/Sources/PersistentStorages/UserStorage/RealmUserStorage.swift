//
//  RealmUserStorage.swift
//  OnboardingData
//
//  Created by JunHyeok Lee on 4/3/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

enum KeychainError: Error {
    case isNullAppBundleID
    case save
    case fetch
    case update
    case delete
    case unknown
}

public final class DefaultUserStorage {
    
    private let realm: Realm
    
    public init(testRealm: Realm? = nil) {
        #if DEBUG
        print("🚨Realm fileURL: \(Realm.Configuration.defaultConfiguration.fileURL)")
        #endif
        if let testRealm = testRealm {
            self.realm = testRealm
            return
        }
        self.realm = try! Realm()
    }
    
    private func save(for userObject: UserObject) -> Bool {
        do {
            try realm.write {
                realm.add(userObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func fetch(for userID: Int) -> UserObject?{
        let userObject = realm.objects(UserObject.self)
        let filteredUserObject = userObject.filter("id == \(userID)")
        return filteredUserObject.first
    }
    
    private func fetchFirst() -> UserObject? {
        let userObject = realm.objects(UserObject.self)
        return userObject.first
    }
    
    private func update(for userObject: UserObject,
                        updatedObject: UserObject) -> UserObject? {
        guard userObject.id == updatedObject.id else { return nil }
        do {
            try realm.write {
                userObject.isAgreeAgePolicy = updatedObject.isAgreeAgePolicy
                userObject.isAgreeAppPolicy = updatedObject.isAgreeAppPolicy
                userObject.isAgreePrivacyPolicy = updatedObject.isAgreePrivacyPolicy
                userObject.isAgreeDaytimeNoti = updatedObject.isAgreeDaytimeNoti
                userObject.isAgreeNighttimeNoti = updatedObject.isAgreeNighttimeNoti
                userObject.accessToken = updatedObject.accessToken
                userObject.refreshToken = updatedObject.refreshToken
            }
            return fetch(for: updatedObject.id)
        } catch {
            return nil
        }
    }
    
    private func delete(for userObject: UserObject) -> Bool {
        do {
            try realm.write {
                realm.delete(userObject)
            }
            return true
        } catch {
            return false
        }
    }
    
    private func deleteAll() -> Bool {
        let userObject = realm.objects(UserObject.self)
        do {
            try realm.write{
                realm.delete(userObject)
            }
            return true
        } catch {
            return false
        }
    }
}

extension DefaultUserStorage: UserStorage {
    public func save(response: UserDTO) -> Single<UserDTO> {
        if let _ = fetch(for: response.id) {
            return update(updatedResponse: response)
        }
        let userObject = UserObject(userDTO: response)
        guard save(for: userObject) else {
            return .error(RealmError.save)
        }
        return get(userID: response.id)
    }
    
    public func get(userID: Int) -> Single<UserDTO> {
        guard let userObject = fetch(for: userID) else {
            return .error(RealmError.fetch)
        }
        return .just(userObject.toDTO())
    }
    
    public func getFirstUser() -> Single<UserDTO> {
        guard let userObject = fetchFirst() else {
            return .error(RealmError.fetch)
        }
        return .just(userObject.toDTO())
    }
    
    public func getTokens(userID: Int) -> Single<(accessToken: String, refreshToken: String)> {
        guard let userObject = fetch(for: userID) else {
            return .error(RealmError.fetch)
        }
        return .just((userObject.accessToken, userObject.refreshToken))
    }
    
    public func update(updatedResponse: UserDTO) -> Single<UserDTO> {
        guard let userObject = fetch(for: updatedResponse.id) else {
            return .error(RealmError.fetch)
        }
        let updateUserObject = UserObject(userDTO: updatedResponse)
        guard let updatedUserObjec = update(for: userObject, updatedObject: updateUserObject) else {
            return .error(RealmError.update)
        }
        return .just(updatedUserObjec.toDTO())
    }
    
    public func delete(userID: Int) -> Single<Void> {
        guard let userObject = fetch(for: userID) else {
            return .error(RealmError.fetch)
        }
        guard delete(for: userObject) else {
            return .error(RealmError.delete)
        }
        return .just(Void())
    }
    
    public func delete() -> Single<Void> {
        guard deleteAll() else {
            return .error(RealmError.delete)
        }
        return .just(Void())
    }
    
    public func saveToKeychain(_ email: String) -> Single<Void> {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return .error(KeychainError.isNullAppBundleID)
        }
        
        let saveQuery: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleID as AnyObject,
            kSecAttrAccount as String: "appleEmail" as AnyObject,
            kSecValueData as String: email as AnyObject,
        ]
        
        let status = SecItemAdd(saveQuery, nil)
        guard status == errSecSuccess else {
            return .error(KeychainError.save)
        }
        return .just(Void())
    }
    
    public func getEmailFromKeychain() -> Single<String> {
        guard let _ = Bundle.main.bundleIdentifier else {
            return .error(KeychainError.isNullAppBundleID)
        }
        
        let selectQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "appleEmail" as AnyObject,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(selectQuery, &result)
        
        guard status == errSecSuccess,
              let email = result as? String else {
            return .error(KeychainError.fetch)
        }
        return .just(email)
    }
    
    public func updateEmailToKeychain(_ email: String) -> Single<String> {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return .error(KeychainError.isNullAppBundleID)
        }
        
        let updateQuery: NSDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: bundleID as AnyObject,
            kSecAttrAccount as String: "appleEmail" as AnyObject,
            kSecValueData as String: email as AnyObject,
        ]
        
        let attributes: NSDictionary = [
            kSecValueData as String: email as AnyObject
        ]
        
        let status = SecItemUpdate(updateQuery, attributes)
        
        guard status == errSecSuccess else {
            return .error(KeychainError.update)
        }
        return getEmailFromKeychain()
    }
    
    public func deleteEmailFromKeychain() -> Single<Void> {
        guard let bundleID = Bundle.main.bundleIdentifier else {
            return .error(KeychainError.isNullAppBundleID)
        }
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: bundleID as AnyObject,
            kSecAttrAccount as String: "appleEmail" as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            return .error(KeychainError.delete)
        }
        return .just(Void())
    }
}
