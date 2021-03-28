//
//  ListsTableViewController.swift
//  ToDoApp
//
//  Created by Егор Костюхин on 21.03.2021.
//

import UIKit

class ListsTableViewController: UITableViewController {

    var lists: [List]!
    
    override func viewWillAppear(_ animated: Bool) {
        lists = StorageManager.shared.fetchData()
        tableView.reloadData()
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
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (_, _, _) in
            StorageManager.shared.delete(taskList: self.lists[indexPath.row])
            self.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] (_, _, isDone) in
            AlertController.showAlert(ofType: .edit,
                                      forObject: .list) { (alert) in
                self.lists[indexPath.row].name = alert.textFields?.first?.text
                self.lists[indexPath.row].note = alert.textFields?.last?.text
                StorageManager.shared.saveContext()
                self.tableView.reloadData()
                
            } presentingClouser: { (alert) in
                present(alert, animated: true)
            }

            isDone(true)
        }
        editAction.backgroundColor = .magenta
        
        let actions = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return actions
    }

    
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
         let tasksVC = segue.destination as! TasksTableViewController
        tasksVC.currentList = lists[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)        
    }

    @IBAction func addNewList(_ sender: Any) {
        AlertController.showAlert(ofType: .add, forObject: .list) { (alert) in
            StorageManager.shared.addNewTaskList { [unowned self] (newList) in
                newList.name = alert.textFields?.first?.text
                newList.note = alert.textFields?.last?.text
                newList.date = Date()
                self.lists.append(newList)
                let index = IndexPath(row: self.lists.count - 1, section: 0)
                self.tableView.insertRows(at: [index], with: .automatic)
            }
        } presentingClouser: { (alert) in
            present(alert, animated: true)
        }

    }
    
}
