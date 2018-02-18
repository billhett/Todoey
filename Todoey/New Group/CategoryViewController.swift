//
//  CategoryViewController.swift
//  Todoey
//
//  Created by William Hettinger on 2/10/18.
//  Copyright © 2018 William Hettinger. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        print("categories loaded")
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //if nil return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }
    
    //MARK: - TableView Manipulation Methods
    // loadCategories
    func loadCategories() {
        
        categories = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    
    // saveCategories
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error saving categories: \(error)")
        }
        tableView.reloadData()
    }
    //MARK: - Add New Categories
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        print(" add button pressed")
        var textField = UITextField()
        print("alert next")
        let alert = UIAlertController(title: "Add List Category", message: "", preferredStyle: .alert)
        print("action next")
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            

            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}
