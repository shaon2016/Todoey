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
    private var itemArray = [Item]()
    // Getting the first path as it is array
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initVar()
        initView()
    }
    
    func initVar() {
        
        let item1 = Item()
        item1.title = "Ashiq"
        let item2 = Item()
        item2.title = "Shaon"
        let item3 = Item()
        item3.title = "Nadim"
        
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
    }
    
    func initView() {
        loadItems()
    }
    
    func loadItems() {
       if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
        
        do {
          itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error in item decoding")
        }
        
       }
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        if item.done == true {
            cell.accessoryType = .checkmark
        }else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        // This is our action button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item()
            item.title = textFiled.text!
            
            self.itemArray.append(item)
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Item"
            textFiled = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem()  {
        let encoder = PropertyListEncoder()
        do {
            let data =  try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error in Item array encoding")
        }
        
        self.tableView.reloadData()
    }
}

