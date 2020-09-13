//
//  UserTableViewController.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/12.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa

final class UserTableViewController: UIViewController {
    
    // MARK: - Properties
    var disposeBag = DisposeBag()

    private var page: BehaviorRelay<String?> = .init(value: "0")
    private var per_page: BehaviorRelay<String?> = .init(value: "20")
    
    private var viewModel: UserTableViewModel
    
    private var refreshControlFecting: Binder<Bool> {
        return Binder(refreshControl) { (refreshControl, value) in
            value ? refreshControl.beginRefreshing() : refreshControl.endRefreshing()
        }
    }
    private var tableViewDeselect: Binder<IndexPath> {
        return Binder(tableView) { (tableView, value) in
            tableView.deselectRow(at: value, animated: true)
        }
    }
    
    // MARK: - UI Components
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellType: UserTableViewCell.self)
        return tableView
    }()
    private let refreshControl: UIRefreshControl = .init()
    
    // MARK: - Con(De)structor
    
    init() {
        self.viewModel = UserTableViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden: BaseViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        setProperties()
        view.addSubview(tableView)
        layout()
        
        self.per_page = .init(value: "20")
    }
    
    // MARK: - Binding
    
    private func bindViewModel() {

        // Input
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear))
            .take(1)
            .mapToVoid()
        let pullToRefresh = refreshControl.rx.controlEvent(.valueChanged).asObservable()
        
        let trigger = Observable.merge(viewWillAppear, pullToRefresh)
        let param = Observable.combineLatest(page, per_page) { ($0, $1) }

        let request: Observable<(String?, String?)> = Observable.combineLatest(trigger, param) { (trigger, param) in
            print(param)
            return (param.0, param.1)
        }

        let input = type(of: viewModel).Input(
                      request: request.asDriverOnErrorJustNever())
        
        // Output
        let output = viewModel.transform(input: input)
        
        output.fetching
            .drive(refreshControlFecting)
            .disposed(by: disposeBag)
        
        output.users
            .drive(tableView.rx.items(
                cellIdentifier: UserTableViewCell.reuseIdentifier,
                cellType: UserTableViewCell.self)) { index, model, cell in
                cell.configure(with: model, index: index)
                    print(index)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private methods
    
    private func setProperties() {
        view.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Layout

extension UserTableViewController {
    
    private func layout() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

// MARK: - UITableViewDelegate

extension UserTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 128
    }
    
}

