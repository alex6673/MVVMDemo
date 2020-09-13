//
//  ViewController.swift
//  MVVMDemo
//
//  Created by Alex Chang on 2020/9/13.
//  Copyright © 2020 Alex Chang. All rights reserved.
//

import Foundation
import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
        let vc = UserTableViewController()
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        vc.modalPresentationStyle = .popover
        
        self.definesPresentationContext = true
        
        self.present(vc, animated: true)
        
    }

}
