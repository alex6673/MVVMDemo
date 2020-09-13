//
//  APIService.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import Moya

enum APIService {
    case users(page: String?, per_page: String?)
    case user(login: String)
}


// MARK: - TargetType

extension APIService: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .user(let login):
            return "/users/" + login
        }
    }
    
    var method: Method {
        return .get
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .users(let page, let per_page):
            var parameters = [String: Any]()
            
            parameters["page"] = 0
            parameters["per_page"] = 20
            
            if let page = page {
                parameters["page"] = page
            }
            if let per_page = per_page {
                parameters["per_page"] = per_page
            }

            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .user(_):
            
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/vnd.github.v3+json"]
    }
}

