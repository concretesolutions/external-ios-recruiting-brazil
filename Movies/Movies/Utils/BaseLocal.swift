//
//  BaseLocal.swift
//  Movies
//
//  Created by Alexandre Thadeu on 05/08/19.
//  Copyright © 2019 AlexandreThadeu. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BaseLocal {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var context: NSManagedObjectContext? {
        if let appDelegate = appDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
}
