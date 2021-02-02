//
//  TableViewController.swift
//  ToDoList
//
//  Created by User on 10.08.2020.
//  Copyright © 2020 sad. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var arrayTasks = [Entity]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTasks()
    }
    
    func getTasks() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let request: NSFetchRequest<Entity> = Entity.fetchRequest()

        do {
            arrayTasks = try context.fetch(request)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func addTask(_ sender: UIBarButtonItem) {
        createAllert()
    }
    
    func createAllert() {
        let alertController = UIAlertController(title: "Add Task", message: "Add new task", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (alertAction) in
            guard let textField = alertController.textFields?[0] else { return }
            guard let text = textField.text else { return }
            self.saveTask(task: text)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addTextField { (textField) in
        }
        alertController.addAction(alertAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    func saveTask(task: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context) else { return }
        guard let taskObject = NSManagedObject(entity: entity, insertInto: context) as? Entity else { return }

        taskObject.taskToDo = task

        do {
            try context.save()
            arrayTasks.append(taskObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayTasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let taskArray = arrayTasks[indexPath.row]
        
        cell.textLabel?.text = taskArray.taskToDo
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToDelete = arrayTasks[indexPath.row]
    
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context = appDelegate.persistentContainer.viewContext
            
            context.delete(taskToDelete)
            arrayTasks.remove(at: indexPath.row)
            
            do {
                try context.save()
                tableView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

