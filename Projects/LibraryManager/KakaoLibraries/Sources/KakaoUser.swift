//
//  KakaoUser.swift
//  KakaoLibraries
//
//  Created by JunHyeok Lee on 4/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

protocol KakaoSDKUserServicable {
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk(completion: @escaping (Result<String?, Error>) -> Void)
    func loginWithKakaoTalk() -> Single<String>
    func loginWithKakaoAccount(completion: @escaping (Result<String?, Error>) -> Void)
    func loginWithKakaoAccount() -> Single<String>
    func loadUserNickname() -> Single<String>
    func loadUserID() -> Single<Int>
}

final class KakaoSDKUserService: KakaoSDKUserServicable {
    
    private let disposeBag = DisposeBag()
    
    func isKakaoTalkLoginAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
    
    func loginWithKakaoTalk(completion: @escaping (Result<String?, Error>) -> Void) {
        UserApi.shared.loginWithKakaoTalk() { oauthToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(oauthToken?.accessToken))
        }
    }
    
    func loginWithKakaoTalk() -> Single<String> {
        return .create() { single in
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext: { oauthToken in
                    single(.success(oauthToken.accessToken))
                }, onError: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func loginWithKakaoAccount(completion: @escaping (Result<String?, Error>) -> Void) {
        UserApi.shared.loginWithKakaoAccount() { oauthToken, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(oauthToken?.accessToken))
        }
    }
    
    func loginWithKakaoAccount() -> Single<String> {
        return .create() { single in
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext: { oauthToken in
                    single(.success(oauthToken.accessToken))
                }, onError: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func loadUserNickname() -> Single<String> {
        return .create() { single in
            UserApi.shared.rx.me()
                .map { user -> User in
                    var scopes: [String] = []
                    
                    if (user.kakaoAccount?.profileNicknameNeedsAgreement == true) {
                        scopes.append("profileNickname")
                    }
                    
                    if (scopes.count > 0) {
                        throw SdkError(scopes: scopes)
                    } else {
                        return user
                    }
                }
    //            .retry(when: Auth.shared.rx.incrementalAuthorizationRequired())
                .subscribe(onSuccess: { user in
                    guard let nickname = user.properties?["nickname"] else { return }
                    single(.success(nickname))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    func loadUserID() -> Single<Int> {
        return .create() { single in
            UserApi.shared.rx.me()
                .subscribe(onSuccess: { user in
                    guard let userID = user.id else { return }
                    single(.success(Int(userID)))
                }, onFailure: { error in
                    single(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
