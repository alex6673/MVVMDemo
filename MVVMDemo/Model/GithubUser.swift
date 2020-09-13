//
//  GithubUser.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

struct GithubUser: Decodable {
    var login: String?
    var id: Int64?
    var node_id: String?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var type: String?
    var site_admin: Bool?
}
