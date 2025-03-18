//
//  AlertManager.swift
//  Chart
//
//  Created by Petar  on 18.3.25..
//

import UIKit

class AlertManager {
    
    //MARK: - Public API
    class func showOkAlert(viewController: UIViewController, title: String? = nil, message: String? = nil,
                            okBtnTitle: String? = "OK", onClosed: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.modalPresentationStyle = .fullScreen
        alert.addAction(UIAlertAction(title: okBtnTitle, style: .default, handler: { _ in
            onClosed?()
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
