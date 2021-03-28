//
//  AlertController.swift
//  ToDoApp
//
//  Created by Егор Костюхин on 21.03.2021.
//

import Foundation
import UIKit

class AlertController: UIAlertController {
    
    let shared = AlertController()
    
    enum objects {
        case list, task
    }
    
    enum types {
        case delete, edit, add
    }

    static func showAlert(ofType type: types, forObject object: objects, alertActionClouser: @escaping (UIAlertController) -> Void, presentingClouser: (UIAlertController) -> Void) {
        
        var title = ""
        var message = ""
        var actionButton = ""
        
        switch type {
        case .delete:
            title = "Delete "
            message = "You are about to delete the "
            actionButton = "Delete"
        case .edit:
            title = "Edit "
            message = "You are about to edit the "
            actionButton = "Edit"
        case .add:
            title = "Add "
            message = "You are about to add new "
            actionButton = "Add"
        }
        
        switch object {
        case .list:
            title += "list"
            message += "list."
        case .task:
            title += "task"
            message += "task."
        }
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "\(title) name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "\(title) description (optional)"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) {(_) in
            
        }
        
        let action = UIAlertAction(title: actionButton, style: .default) { (_) in
            // in order to perform action the following clouser was prepared:
            alertActionClouser(alert)
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        // in order to implement method present(alert, animated: true) made a clouser:
        
        presentingClouser(alert)
        
    }
    
    
}
