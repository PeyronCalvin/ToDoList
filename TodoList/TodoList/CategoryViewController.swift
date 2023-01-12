//
//  CategoryViewController.swift
//  TodoList
//
//  Created by user226225 on 1/10/23.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryListTableView: UITableView!
    var items = [
        ToDo(name: "Contrôle technique", desc: "Faire passer le contrôle technique à la voiture", dueTo: Date(timeIntervalSinceNow: 10000000.0)),
        ToDo(name: "Vaisselle", desc: "Faire la vaisselle", dueTo: Date(timeIntervalSinceNow: 100000.0)),
        ToDo(name: "Lessive", desc: "Faire la lessive", dueTo: Date(timeIntervalSinceNow: 100000.0)),
        ToDo(name: "Roller", desc: "Aller faire du roller au lac Kir", dueTo: Date(timeIntervalSinceNow: 200000.0)),
        ToDo(name: "Pneus", desc: "Passer aux pneus été", dueTo: Date(timeIntervalSinceNow: 200000.0)),
        ToDo(name: "Révisions", desc: "Réviser le cours", dueTo: Date(timeIntervalSinceNow: 1.0)),
        ToDo(name: "Courses", desc: "Acheter des oeufs et du poisson", dueTo: Date(timeIntervalSinceNow: 1.0)),
        ToDo(name: "Partiel", desc: "Réviser comme un acharné pour réussir", dueTo: Date(timeIntervalSinceNow: 120000.0))
    ]
    var categories = [ToDoList]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        categories = [
            ToDoList(name:"Tâches ménagères", todos:[items[1],items[2],items[6]]),
            ToDoList(name:"Mécanique", todos:[items[0],items[4]]),
            ToDoList(name:"Travail", todos:[items[5],items[7]]),
            ToDoList(name:"Entertainment", todos:[items[3]])
        ]
        categoryListTableView.delegate = self
        categoryListTableView.dataSource = self
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var nameField = UITextField()
        
        let alert = UIAlertController(title: "add new category", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default){(save) in
            let newCategory = ToDoList(name: nameField.text!, todos: [])
            self.categories.append(newCategory)
            self.categoryListTableView.reloadData()
        }
        
        alert.addTextField{(text) in
            nameField = text
            nameField.placeholder = "ToDo name"
        }
        
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        var nameField = UITextField()
        
        let alert = UIAlertController(title: "delete item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default){(save) in
            var index = [Int]()
            for i in 0...self.categories.count-1{
                if(self.categories[i].name==nameField.text!){
                    index.append(i)
                }
            }
            index.sort(by: >)
            for elt in index{
                self.categories.remove(at: elt)
            }
            self.categoryListTableView.reloadData()
        }
        
        alert.addTextField{(text) in
            nameField = text
            nameField.placeholder = "ToDo name"
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let viewController = segue.destination as? ViewController{
            let row = self.categoryListTableView.indexPathForSelectedRow!.row
            let category = categories[row]
            viewController.items = category.todos
            viewController.itemsFiltered = category.todos
            viewController.category = row
            
        }
    }

}

extension CategoryViewController : UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = categories[indexPath.row].name
        return cell
    }
        
}


