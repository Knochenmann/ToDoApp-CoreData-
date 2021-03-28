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
    }
    // MARK: - Apperance
    
    
    @objc private func showAddingAlert() {
        let alert = UIAlertController(title: "New Task",
                                      message: "Add new task",
                                      preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type a task"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Add a note"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self] (_) in
            
            StorageManager.shared.addNewTask { [unowned self] (newTask) in
                newTask.name = alert.textFields?.first?.text
                newTask.note = alert.textFields?.last?.text
                newTask.date = Date()
                newTask.isCompleted = false
                currentList.addToTasks(newTask)
                tasks?.append(newTask)
                let index = IndexPath(row: self.tasks!.count - 1, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [unowned self] (_) in
            self.dismiss(animated: true)
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = tasks?[indexPath.row].name
        content.secondaryText = tasks?[indexPath.row].note
        cell.contentConfiguration = content

        return cell
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.shared.delete(task: (self.tasks![indexPath.row]))
            self.tasks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, isDone) in
            AlertController.showAlert(ofType: .edit,
                                      forObject: .task) { (alert) in
                self.tasks?[indexPath.row].name = alert.textFields?.first?.text
                self.tasks?[indexPath.row].note = alert.textFields?.last?.text
                StorageManager.shared.saveContext()
                self.tableView.reloadData()
            } presentingClouser: { (alert) in
                self.present(alert, animated: true)
            }
            
            isDone(true)
        }
        
        let completeAction = UIContextualAction(style: .normal, title: "Complete") { (_, _, isDone) in
            self.tasks?[indexPath.row].isCompleted.toggle()
            StorageManager.shared.saveContext()
            isDone(true)
            
        }
        
        editAction.backgroundColor = .magenta
        completeAction.backgroundColor = .systemGreen
        
        let actions = UISwipeActionsConfiguration(actions: [completeAction, editAction, deleteAction])
        
        return actions
    }
    
    deinit {
        print("TasksVC has been dealocated")
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        AlertController.showAlert(ofType: .add,
                                  forObject: .task) { (alert) in
            
            StorageManager.shared.addNewTask { [unowned self] (newTask) in
                newTask.name = alert.textFields?.first?.text
                newTask.note = alert.textFields?.last?.text
                newTask.date = Date()
                newTask.isCompleted = false
                currentList.addToTasks(newTask)
                tasks?.append(newTask)
                let index = IndexPath(row: self.tasks!.count - 1, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)
            }
            
        }
                                presentingClouser: { (alert) in
            self.present(alert, animated: true)
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
