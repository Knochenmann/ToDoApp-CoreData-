//
//  StorageManager.swift
//  ToDoApp
//
//  Created by Егор Костюхин on 21.03.2021.
//

import Foundation
import CoreData

class StorageManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "ToDoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        let context = persistentContainer.viewContext
        return context
    }
    
    static let shared = StorageManager()
    
    private init() {}
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func fetchData() -> [List] {
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch let error {
            print(error)
            return []
        }
    }
    
    // MARK: - Adding Functions
    
    func addNewTaskList(completion: @escaping (List) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "List", in: context) else { return }
        guard let newList = NSManagedObject(entity: entityDescription, insertInto: context) as? List else { return }
        
        completion(newList)
        
        saveContext()
        
    }
    
    func addNewTask(completion: @escaping (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        guard let newTask = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        completion(newTask)
        
        saveContext()
    }
    
    // MARK: - Deleting Functions
    
    func delete(taskList: List) {
        context.delete(taskList)
        saveContext()
    }
    
    func delete(task: Task) {
        context.delete(task)
        saveContext()
    }
    
    // MARK: - Editing Functions
    
    func edit(taskList: List, name: String, note: String) {
        taskList.name = name
        taskList.note = note
        taskList.date = Date()
        saveContext()
    }
    
    
}
