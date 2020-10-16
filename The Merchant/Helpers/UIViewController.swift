//
//  UIViewController.swift
//  The Merchant
//
//  Created by Kyle Gardner on 9/2/20.
//  Copyright © 2020 Kyle Gardner. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createAlertController(title: String, message: String, btnText: String = "Okay") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: btnText, style: .default, handler: nil)
        alertController.addAction(retryAction)
        self.present(alertController, animated: true, completion:  nil)
    }
}
