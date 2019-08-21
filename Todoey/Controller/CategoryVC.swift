//
//  CategoryVC.swift
//  Todoey
//
//  Created by MacBook Pro  on 21/8/19.
//  Copyright © 2019 MacBook Pro . All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        catCell.textLabel?.text =  categories[indexPath.row].name
        
        return catCell
    }
    
    // MARK: - TableView delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListVC
        
        if let indexPath = tableView.indexPathForSelectedRow {
               destinationVC.selectedCat =  categories[indexPath.row]
        }
    }
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: nil, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
             let catName = textField.text!
            let cat = Category(context: self.context)
             cat.name = catName
             self.categories.append(cat)
            
            self.saveCategories()
    
        }
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.placeholder = "Add new category"
        }
        
        alert.addAction(action)
        
        present(alert, animated: true , completion: nil)
    }
    
    func saveCategories()  {
        do {
            try self.context.save()
        } catch {
            print("Error  in saving category : \(error)")
        }
         tableView.reloadData()
    }
    
    func loadItems()   {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
          try categories = context.fetch(request)
        } catch {
            print("Error in fetching category data: \(error)")
        }
        
        tableView.reloadData()
    }
}
