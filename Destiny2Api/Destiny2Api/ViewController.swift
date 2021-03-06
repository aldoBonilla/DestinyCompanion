//
//  ViewController.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    private var safariVC: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyToken()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func verifyToken() {
        
        LoginWorker.shared.validateCurrentToken() { error in
            if error != nil {
                self.safariVC = SFSafariViewController(url: URL(string: "https://www.bungie.net/en/oauth/authorize?client_id=23342&response_type=code&requth=true")!)
                DispatchQueue.main.async {
                    self.present(self.safariVC!, animated: true, completion: nil)
                }
            } else {
                self.getUserInfo()
            }
        }
    }
    
    private func getUserInfo() {
        UserWorker.basicCurrentUserInfo() { error in
            if let workerError = error {
                DispatchQueue.main.async {
                    showSimpleAlertWithTitle(title: "Error", message: workerError.description, viewController: self)
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                }
            }
        }
    }

    public func doLoginWith(code: String) {
        LoginWorker.shared.doLogin(with: code) { error in
            if let workerError = error {
                showSimpleAlertWithTitle(title: "Error", message: workerError.description, viewController: self)
            } else {
                DispatchQueue.main.async {
                    self.safariVC!.dismiss(animated: true) {
                        self.getUserInfo()
                    }
                }
            }
        }
    }

}

