//
//  APIProvider.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

final class APIRequest {
    
    static let shared = APIRequest()
    
    private let provider = APIProvider<APIService>()
    
    // MARK: - Properties
    var disposeBag = DisposeBag()

    func getUsers(page: String?, per_page: String?, fetching: PublishRelay<Bool>) -> Driver<[GithubUser]> {

        print("getUsers");
        return provider.request([GithubUser].self, token: .users(page: page, per_page: per_page))
            .do(onSuccess: { (_) in
                fetching.accept(false)
            }, onError: { (_) in
                fetching.accept(false)
            }, onSubscribe: {
                fetching.accept(true)
            })
            .asDriver(onErrorJustReturn: [])
    }
    
}
