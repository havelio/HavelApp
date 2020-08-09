//
//  UIViewController.swift
//  HavelApp
//
//  Created by Havelio Henar on 08/08/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "", message: String, onFinish: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.view.tintColor = .black

        if onFinish != nil {
            alertController.addAction(UIAlertAction(title: "Close", style:
                .default, handler: { _ in
            onFinish!()
            }))
        } else {
            alertController.addAction(UIAlertAction(title: "Close", style:
                .default, handler: nil))
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func refreshValueDidChange() {
        print("Subclass has not implemented abstract method `refreshValueDidChange`!")
        abort()
    }
}
