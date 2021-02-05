//
//  ViewController.swift
//  ToDoList
//
//  Created by guntars.grants on 04/02/2021.
//

import UIKit
import CoreData

class ToDoTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var toDoList = [ToDo]()
    

    @IBOutlet weak var tableView: UITableView!
    
    var context: NSManagedObjectContext?

    override func viewDidLoad(){
        super.viewDidLoad()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    context = appDelegate.persistentContainer.viewContext
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }

    @IBAction func addNewItemTapped(_ sender: Any) {
        addNewItem()
        //addAnotherNewItem()
    }

    
    private func addNewItem(){
        let alertController = UIAlertController(title: "Add New To Do Task.", message: "What do you want to add?", preferredStyle: .alert)
        
        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Enter the title of your task."
            textField.autocapitalizationType = .sentences
            textField.autocorrectionType = .no
        }
//        alertController.addTextField { (textField: UITextField) in
//            textField.placeholder = "Enter how much time you have to do your task."
//            textField.autocapitalizationType = .sentences
//            textField.autocorrectionType = .no
//        }
        
        
        let addAction = UIAlertAction(title: "Add", style: .cancel) { (action: UIAlertAction) in
            let textField = alertController.textFields?.first
//            let textFieldA = alertController.textFields?[1]
            
            let entity = NSEntityDescription.entity(forEntityName: "ToDo", in: self.context!)
            let item = NSManagedObject(entity: entity!, insertInto: self.context)
            item.setValue(textField?.text, forKey: "item")
//            let time = NSManagedObject(entity: entity!, insertInto: self.context)
//            time.setValue(textFieldA?.text, forKey: "time")
//            print(time)
            //Save function
            self.saveData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        alertController.addAction(addAction)
        present(alertController, animated: true)
    }
    
    func loadData(){
        let request: NSFetchRequest<ToDo> = ToDo.fetchRequest()
        do {
            let result = try context?.fetch(request)
            toDoList = result!
        } catch {
            fatalError(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    func saveData(){
        do {
            try self.context?.save()
        }catch{
            fatalError(error.localizedDescription)
        }
        //loadData()
        loadData()
    }
    
    //MARK: - Table view data source
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoList.count
        }
         func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell",for: indexPath)
//            let timeCell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
          
            let item = toDoList[indexPath.row]
            cell.textLabel?.text = item.value(forKey: "item") as? String
            cell.accessoryType = item.completed ? .checkmark : .none
            cell.selectionStyle = .none
            return cell
        }
        
        
    
    //MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        toDoList[indexPath.row].completed = !toDoList[indexPath.row].completed
        saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete?", message: "Are you sure you want to delete?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                
                let item = self.toDoList[indexPath.row]
                
                self.context?.delete(item)
                self.saveData()
                
                
            }))
            self.present(alert, animated: true)
        }
    }
    
}

