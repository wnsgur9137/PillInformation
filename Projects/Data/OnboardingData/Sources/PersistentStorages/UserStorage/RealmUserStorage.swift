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

enum RealmError: Error {
    case save
    case fetch
    case update
    case delete
}

public final class RealmUserStorage {
    
    private let realm: Realm
    
    public init() { 
        self.realm = try! Realm()
        #if DEBUG
        print("🚨Realm fileURL: \(Realm.Configuration.defaultConfiguration.fileURL)")
        #endif
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
}

extension RealmUserStorage: UserStorage {
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
}
