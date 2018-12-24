//
//  ViewController.swift
//  Todoey
//
//  Created by Cristi Raduca on 20/12/2018.
//  Copyright © 2018 Cristi Raduca. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item] ()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
            tableView.reloadData()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item]
//        {
//            itemArray = items
//        }
//
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray [indexPath.row].title
        
        if itemArray[indexPath.row].done == true{
            cell.accessoryType = .checkmark
        }
        else
        {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        if itemArray[indexPath.row].done == true
        {
            itemArray[indexPath.row].done = false
        }
        else
        {
            itemArray[indexPath.row].done = true
        }
        
        saveItems()
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//        else
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // What will happen when the user clicks the Add Item button on our UIAlert
            if(textField.text != nil)
            {
            let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
               
            }
        }
       
        alert.addAction(action)
        alert.addTextField {
            (alertTextField) in
            alertTextField.placeholder = "Create new item"
            print(alertTextField.text!)
            textField = alertTextField
        }
        present(alert, animated:  true, completion: nil)
    }
    
    func saveItems() {
    do{
        try context.save()
    }
    catch{
        print("Error saving context \(error)")
    }
        tableView.reloadData()
    }
    
    func loadItems(predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate (andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else
        {
            request.predicate = categoryPredicate
        }

        do{
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context \(error)")
        }
    }
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        do{
            itemArray = try context.fetch(request)
        }
        catch
        {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0
        {
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
           
        }
    }
    
}
