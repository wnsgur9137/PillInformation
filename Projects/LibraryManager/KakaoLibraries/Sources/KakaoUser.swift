//
//  KakaoUser.swift
//  KakaoLibraries
//
//  Created by JunHyeok Lee on 4/5/24.
//  Copyright © 2024 com.junhyeok.PillInformation. All rights reserved.
//

import Foundation
import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser

protocol KakaoSDKUserServicable {
    func isKakaoTalkLoginAvailable() -> Bool
    func loginWithKakaoTalk(completion: @escaping (Result<String?, Error>) -> Void)
    func loginWithKakaoTalk() -> Single<String>
    func loginWithKakaoAccount(completion: @escaping (Result<String?, Error>) -> Void)
    func loginWithKakaoAccount() -> Single<String>
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
}
