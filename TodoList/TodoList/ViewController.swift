//
//  ViewController.swift
//  TodoList
//
//  Created by user226225 on 12/24/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    var items = [ToDo]()
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let itemViewController = segue.destination as! ItemViewController
        let item = items[self.todoListTableView.indexPathForSelectedRow!.row]
        itemViewController.nameReceived = item.name
        itemViewController.descReceived = item.desc
        itemViewController.dueToReceived = item.dueTo
        itemViewController.createdAtReceived = item.createdAt
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        
        var idField = UITextField()
        var nameField = UITextField()
        var descField = UITextField()
        var dateField = UITextField()
        
        let alert = UIAlertController(title: "modify item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default){(save) in
            let id = idField.text!
            if id != ""{
                if (Int(id)! >= 0) && (Int(id)!<self.items.count){
                    let item = self.items[Int(id)!]
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date = try? dateFormatter.date(from: dateField.text!)
                    if date != nil{
                        item.dueTo = date!
                    }
                    if nameField.text != nil{
                        item.name = nameField.text!
                    }
                    if descField.text != nil{
                        item.desc = descField.text!
                    }
                    print("here")
                    self.items[Int(id)!] = item
                }
            self.todoListTableView.reloadData()
            }
        }
        
        alert.addTextField{(text) in
            idField = text
            idField.placeholder = "ToDo id"
        }
        alert.addTextField{(text) in
            nameField = text
            nameField.placeholder = "ToDo name"
        }
        alert.addTextField{(text) in
            descField = text
            descField.placeholder = "ToDo desc"
        }
        alert.addTextField{(text) in
            dateField = text
            dateField.placeholder = "yyyy-MM-dd"
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        var nameField = UITextField()
        var descField = UITextField()
        var dateField = UITextField()
        
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default){(save) in
            let stringDate = dateField.text!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = try? dateFormatter.date(from: stringDate)
            if !(date == nil){
                let newToDo = ToDo(name: nameField.text!, desc: descField.text!, dueTo:date!)
                self.items.append(newToDo)
                self.todoListTableView.reloadData()
            }
        }
        
        alert.addTextField{(text) in
            nameField = text
            nameField.placeholder = "ToDo name"
        }
        alert.addTextField{(text) in
            descField = text
            descField.placeholder = "ToDo desc"
        }
        alert.addTextField{(text) in
            dateField = text
            dateField.placeholder = "yyyy-MM-dd"
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
            for i in 0...self.items.count-1{
                if(self.items[i].name==nameField.text!){
                    index.append(i)
                }
            }
            index.sort(by: >)
            for elt in index{
                self.items.remove(at: elt)
            }
            self.todoListTableView.reloadData()
        }
        
        alert.addTextField{(text) in
            nameField = text
            nameField.placeholder = "ToDo name"
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = items[indexPath.row].name
        return cell
    }
    	
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "viewItem") as! ItemViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
