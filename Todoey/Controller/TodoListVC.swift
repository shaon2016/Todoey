//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook Pro  on 13/8/19.
//  Copyright © 2019 MacBook Pro . All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {
    
    private let userPrefDefualts = UserDefaults.standard
    private var itemArray = ["Shaon", "Ashiq", "Nadim"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initVar()
    }

    func initVar() {
        if let items = userPrefDefualts.array(forKey: "items") as? [String] {
            itemArray = items
        }
        
    }
    
    func initView() {
        
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        // This is our action button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            self.itemArray.append(textFiled.text!)
            self.userPrefDefualts.set(self.itemArray, forKey: "items")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}

