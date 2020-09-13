//
//  Extensions.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}

extension UITableViewHeaderFooterView: Reusable {}

extension UITableView {
    
    final func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError(
                "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the cell beforehand"
            )
        }
        return cell
    }
    
    final func register<T: UITableViewHeaderFooterView>(headerFooterViewType: T.Type) {
        register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
    
    final func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ viewType: T.Type = T.self) -> T? {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.reuseIdentifier) as? T? else {
            fatalError(
                "Failed to dequeue a header/footer with identifier \(viewType.reuseIdentifier) "
                    + "matching type \(viewType.self). "
                    + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                    + "and that you registered the header/footer beforehand"
            )
        }
        return view
    }
    
}

extension ObservableType where E == Bool {
    
    func not() -> Observable<Bool> {
        return map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
    
}

extension ObservableType {
    
    func catchErrorJustNever() -> Observable<E> {
        return catchError { _ in
            return Observable.never()
        }
    }
    
    func catchErrorJustComplete() -> Observable<E> {
        return catchError { _ in
            return Observable.empty()
        }
    }
    
    func asDriverOnErrorJustNever() -> Driver<E> {
        return asDriver(onErrorDriveWith: .never())
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
}

extension PrimitiveSequence {
    
    func asDriverOnErrorJustNever() -> Driver<E> {
        return asDriver(onErrorDriveWith: .never())
    }
    
    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver(onErrorDriveWith: .empty())
    }
    
}
