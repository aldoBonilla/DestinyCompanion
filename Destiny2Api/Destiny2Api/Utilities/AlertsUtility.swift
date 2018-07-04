//
//  View_Utilities.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 16/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import UIKit

func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController?) {
    if viewController == nil {
        AppDelegate().presentAlertFromRootViewController(title: title, message: message)
        return
    }
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    viewController!.present(alert, animated: true, completion: nil)
}

