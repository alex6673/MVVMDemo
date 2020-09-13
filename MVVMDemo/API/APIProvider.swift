//
//  APIProvider.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/13.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import RxSwift
import Moya

class APIProvider<Target: TargetType>: MoyaProvider<Target> {

    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    // MARK: - Con(De)structor
    
    init(plugins: [PluginType]? = nil) {
        var finalPlugins = plugins ?? [PluginType]()
        finalPlugins.append(MoyaCacheablePlugin())
        super.init(plugins: finalPlugins)
    }
    
    // MARK: - Internal methods
        
    func request<T>(_ modelType: T.Type, token: Target, callbackQueue: DispatchQueue? = nil) -> Single<T> where T: Decodable {
        return self.rx.request(token, callbackQueue: callbackQueue).map(modelType)
    }

    // MARK: - Private methods
    
    private func parse<T>(_ modelType: T.Type, data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(modelType, from: data)
    }
    
}
