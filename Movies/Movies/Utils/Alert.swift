//
//  Alert.swift
//  Movies
//
//  Created by Alexandre Thadeu on 06/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func errorAlert(message: String, controller: UIViewController?) {
        
        guard let controller = controller else {
            return
        }
        
        let alertController = UIAlertController(title: "Aviso", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { alert in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(action)
        
        controller.present(alertController, animated: true)
    }
    
}
