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
            }
            return userObject
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
    public func save(response: UserDTO) -> Single<Void> {
        let userObject = UserObject(
            id: response.id,
            isAgreeAppPolicy: response.isAgreeAppPolicy,
            isAgreeAgePolicy: response.isAgreeAgePolicy,
            isAgreePrivacyPolicy: response.isAgreePrivacyPolicy,
            isAgreeDaytimeNoti: response.isAgreeDaytimeNoti,
            isAgreeNighttimeNoti: response.isAgreeNighttimeNoti,
            accessToken: response.accessToken,
            refreshToken: response.refreshToken
        )
        guard save(for: userObject) else {
            return .error(RealmError.save)
        }
        return .just(Void())
    }
    
    public func get(userID: Int) -> Single<UserDTO> {
        guard let userObject = fetch(for: userID) else {
            return .error(RealmError.fetch)
        }
        return .just(userObject.toDTO())
    }
    
    public func update(userID: Int,
                       updatedResponse: UserDTO) -> Single<UserDTO> {
        guard let userObject = fetch(for: userID) else {
            return .error(RealmError.fetch)
        }
        let updateUserObject = UserObject(
            id: updatedResponse.id,
            isAgreeAppPolicy: updatedResponse.isAgreeAppPolicy,
            isAgreeAgePolicy: updatedResponse.isAgreeAgePolicy,
            isAgreePrivacyPolicy: updatedResponse.isAgreePrivacyPolicy,
            isAgreeDaytimeNoti: updatedResponse.isAgreeDaytimeNoti,
            isAgreeNighttimeNoti: updatedResponse.isAgreeNighttimeNoti,
            accessToken: updatedResponse.accessToken,
            refreshToken: updatedResponse.refreshToken
        )
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
