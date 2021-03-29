//
//  TasksTableViewController.swift
//  ToDoApp
//
//  Created by Егор Костюхин on 23.03.2021.
//

import UIKit

class TasksTableViewController: UITableViewController {

    var currentList: List!
    lazy var tasks = currentList.tasks?
        .sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) as? [Task]
    var completedTasks: [Task]!
    var currentTasks: [Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        title = currentList.name
        currentTasks = tasks?.filter({$0.isCompleted == false})
        completedTasks = tasks?.filter({$0.isCompleted})
        
    }

    
    
    // MARK: - Table view data source
    
    
    
    // MARK: Sections

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current Tasks"
        } else {
            return "Completed Tasks"
        }
    }

    
    // MARK: Rows
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentTasks?.count ?? 0
        } else {
            return completedTasks?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath)
        let section = indexPath.section  == 0 ? currentTasks : completedTasks
            
        var content = cell.defaultContentConfiguration()
        content.text = section?[indexPath.row].name ?? ""
        content.secondaryText = section?[indexPath.row].note ?? ""
        cell.contentConfiguration = content

        return cell
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            if indexPath.section == 0 {
                StorageManager.shared.delete(task: (self.currentTasks[indexPath.row]))
                self.currentTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                StorageManager.shared.delete(task: (self.completedTasks[indexPath.row]))
                self.completedTasks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            
            AlertController.showAlert(ofType: .edit, forObject: .task) { [unowned self] (alert) in
                
                if indexPath.section == 0 {
                    self.currentTasks[indexPath.row].name = alert.textFields?.first?.text
                    self.currentTasks[indexPath.row].note = alert.textFields?.last?.text
                } else {
                    self.completedTasks[indexPath.row].name = alert.textFields?.first?.text
                    self.completedTasks[indexPath.row].note = alert.textFields?.last?.text
                }
                
                StorageManager.shared.saveContext()
                self.tableView.reloadData()
                
            } presentingClouser: { (alert) in
                self.present(alert, animated: true)
            }
            
            isDone(true)
        }
        
        let completionLabel = indexPath.section == 0 ? "Complete" : "Uncomplete"
        
        let completeAction = UIContextualAction(style: .normal, title: completionLabel) { (_, _, isDone) in
            
            if indexPath.section == 0 {
                self.currentTasks?[indexPath.row].isCompleted.toggle()
                self.completedTasks?.append(self.currentTasks![indexPath.row])
                self.currentTasks?.remove(at: indexPath.row)
            } else {
                self.completedTasks?[indexPath.row].isCompleted.toggle()
                self.currentTasks?.append(self.completedTasks![indexPath.row])
                self.completedTasks?.remove(at: indexPath.row)
            }
            tableView.reloadData()
            
            StorageManager.shared.saveContext()
            
            isDone(true)
            
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
        completeAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        let actions = UISwipeActionsConfiguration(actions: [completeAction, editAction, deleteAction])
        
        return actions
    }
    
    
    // MARK: - IBActions
 
    @IBAction func addNewTask(_ sender: Any) {
        AlertController.showAlert(ofType: .add,
                                  forObject: .task) { (alert) in
            
            StorageManager.shared.addNewTask { [unowned self] (newTask) in
                newTask.name = alert.textFields?.first?.text
                newTask.note = alert.textFields?.last?.text
                newTask.date = Date()
                newTask.isCompleted = false
                currentList.addToTasks(newTask)
                currentTasks?.append(newTask)
                let index = IndexPath(row: self.currentTasks!.count - 1, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)
            }
            
        }
                                presentingClouser: { (alert) in
            self.present(alert, animated: true)
        }
    }
    
    deinit {
        print("TasksVC has been dealocated")
    }
}
