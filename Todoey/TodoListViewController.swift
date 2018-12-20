//
//  ViewController.swift
//  Todoey
//
//  Created by Cristi Raduca on 20/12/2018.
//  Copyright © 2018 Cristi Raduca. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Mancanca", "Lucreaza", "Fa sport", "Iubeste", "Repeta"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray [indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        if tableView.cellForRow(at: indexPath)?.accessoryType != .checkmark
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
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
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
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
    
}

