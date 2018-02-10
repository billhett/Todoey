//
//  ViewController.swift
//  Todoey
//
//  Created by William Hettinger on 2/3/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
            //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }
    
    //MARK - Tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none

        
        return cell
    }
    
    //MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //toggles done flag
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemArray[indexPath.row]
        
        print(item.title!)
        let newTitle = item.title! + " completed!"
        itemArray[indexPath.row].setValue(newTitle, forKey: "title")
        
        saveItems()        
    }
    //MARK - Add new items to list
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen when user pressed add item button in UIAlert
            print(textField.text!)
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            self.itemArray.append(newItem)

            self.saveItems()
        }
    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        print("alert.addaction")
        
        present(alert, animated: true, completion: nil)
        print("present alert")
    }
    //MARK - Model Manipulation Methods
    
    func saveItems() {

            do {
                try context.save()
            } catch {
                print("error saving context \(error)")
            }
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {

       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            print("search bar cleared")
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

