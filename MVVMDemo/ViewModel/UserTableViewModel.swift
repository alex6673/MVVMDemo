//
//  UserTableViewModel.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

final class UserTableViewModel {
    private var disposeBag = DisposeBag()
}

// MARK: - ViewModelType

extension UserTableViewModel: ViewModelType {
    
    struct Input {
        let request: Driver<(String?, String?)>
    }
    struct Output {
        let fetching: Driver<Bool>
        let users: Driver<[GithubUser]>
    }
    
    func transform(input: Input) -> Output {
        let fetching: PublishRelay<Bool> = .init()
        let users: Driver<[GithubUser]> = input.request
            .flatMapLatest { [weak self] in
                guard let _ = self else {return .empty()}
                return APIRequest.shared.getUsers(page: $0.0, per_page: $0.1, fetching: fetching)
        }
        
        return Output(
            fetching: fetching.asDriverOnErrorJustNever(),
            users: users
        );
    }
    
    
    
}
