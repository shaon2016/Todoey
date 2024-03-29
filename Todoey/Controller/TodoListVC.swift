//
//  ViewController.swift
//  Todoey
//
//  Created by MacBook Pro  on 13/8/19.
//  Copyright © 2019 MacBook Pro . All rights reserved.
//

import UIKit
import CoreData

class TodoListVC: UITableViewController {
    private let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    // MARK: - Instances
    var selectedCat : Category? {
        didSet {
            loadItems()
        }
    }
    private let userPrefDefualts = UserDefaults.standard
    private var itemArray = [Item]()
    // Getting the first path as it is array
    private let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(dataFilePath!)
        
        initVar()
        initView()
    }
    
    func initVar() {
        
        
    }
    
    func initView() {
        loadItems()
    }
    
    // MARK: -  TableView DataSource Methods
    
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
    
    // MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var textFiled = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        // This is our action button
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = textFiled.text!
            item.done = false
            item.parentCategory = self.selectedCat
            
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
    
    // MARK: - Model manipulation methods
    
    func saveItem()  {
        do {
           try context.save()
        } catch {
            print("Error in Item save \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), with predicate: NSPredicate? = nil) {
        let catPredicate = NSPredicate(format: "parentCategory.name matches %@", selectedCat?.name ?? "")
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = catPredicate
        }
        
        
       do {
            try itemArray = context.fetch(request)
        }catch{
            print("Error in Fetching Item data: \(error)")
        }
        
        tableView.reloadData()
    }
}

// MARK: -  Searchbar delegate
//  Resource:

extension TodoListVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        // [cd] used for case sensitive and dicritic reason, will ignore any case sensitive and dicritic
        let predicate = NSPredicate(format: "title contains[cd] %@", searchBar.text!)
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptr]
    
        loadItems(with: request, with: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

