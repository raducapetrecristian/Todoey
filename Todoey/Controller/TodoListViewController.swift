//
//  ViewController.swift
//  Todoey
//
//  Created by Cristi Raduca on 20/12/2018.
//  Copyright © 2018 Cristi Raduca. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item] ()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadItems()
        
//        print(dataFilePath)
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
            let newItem = Item()
                newItem.title = textField.text!
                
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
    let encoder = PropertyListEncoder()
    do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
    }
    catch{
            print("Error encoding item array : \(error)")
    }
        tableView.reloadData()
    }
    
    func loadItems() {
        if  let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do
            {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch
            {
                print("Error decoding item array : \(error)")
            }
        }
        
    }
    
}
