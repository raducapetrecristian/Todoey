//
//  ViewController.swift
//  Todoey
//
//  Created by Cristi Raduca on 20/12/2018.
//  Copyright © 2018 Cristi Raduca. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Mancanca", "Lucreaza", "Fa sport", "Iubeste", "Repeta"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //Mark - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray [indexPath.row]
        
        return cell
    }
    
    //Mark - TableView Delegate Methods
    
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
    
}

