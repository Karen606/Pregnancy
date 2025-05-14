//
//  MenuViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 14.05.25.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let rootVC = storyboard?.instantiateViewController(withIdentifier: "RootViewController") {
            self.navigationController?.viewControllers = [rootVC]
        }
    }
}
