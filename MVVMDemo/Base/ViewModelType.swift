//
//  ViewModelType.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
