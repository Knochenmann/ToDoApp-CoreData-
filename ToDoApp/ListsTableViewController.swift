//
//  ListsTableViewController.swift
//  ToDoApp
//
//  Created by Егор Костюхин on 21.03.2021.
//

import UIKit

class ListsTableViewController: UITableViewController {

    var lists: [List]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lists = StorageManager.shared.fetchData()
        setupView()

    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
    }
    
    func showAlertOne(with title: String, and message: String) {
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        alert.addTextField { (textField) in
//            textField.placeholder = "Type a list name"
//        }
//        alert.addTextField { (textField) in
//            textField.placeholder = "Add a note"
//        }
//
//        let editAction = UIAlertAction(title: "Edit", style: .default) { (_) in
//            StorageManager.shared.edit(taskList: <#T##List#>, name: <#T##String#>, note: <#T##String#>)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
//            self.dismiss(animated: true)
//        }
//
//
//        alert.addAction(action)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true)
    }
    
    @objc private func showAlert() {
        let alert = UIAlertController(title: "New List", message: "Add new task list", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Type a list name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Add a note"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            StorageManager.shared.addNewTaskList { (newList) in
                newList.name = alert.textFields?.first?.text
                newList.note = alert.textFields?.last?.text
                newList.date = Date()
                self.lists.append(newList)
                let index = IndexPath(row: self.lists.count - 1, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            self.dismiss(animated: true)
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "list", for: indexPath) as! ListsTableViewCell

        cell.listName.text = lists[indexPath.row].name
        cell.listNote.text = lists[indexPath.row].note
        cell.tasks.text = "\(lists[indexPath.row].tasks?.count ?? 0)"
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            //заменить на alert
            StorageManager.shared.delete(taskList: self.lists[indexPath.row])
            self.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (_, _, _) in
            //вставить алерт
        
        }
        editAction.backgroundColor = .magenta
        
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return actions
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
