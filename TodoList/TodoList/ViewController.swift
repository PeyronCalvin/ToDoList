//
//  ViewController.swift
//  TodoList
//
//  Created by user226225 on 12/24/22.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    var items = [ToDo(name: "due to farthest(4th)", desc: "show me the sort", dueTo: Date(timeIntervalSinceNow: 1000.0)), ToDo(name: "due to soon but we got time(2nd)", desc: "show me the sort", dueTo: Date(timeIntervalSinceNow: 10.0)),
        ToDo(name: "due to a long time from now (3rd)", desc: "show me the sort", dueTo: Date(timeIntervalSinceNow: 100.0)),
        ToDo(name: "due to really soon", desc: "show me the sort", dueTo: Date(timeIntervalSinceNow: 1.0))]
    var placeToErase = 0
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let itemViewController = segue.destination as? ItemViewController{
            let row = self.todoListTableView.indexPathForSelectedRow!.row
            let item = items[row]
            itemViewController.nameReceived = item.name
            itemViewController.descReceived = item.desc
            itemViewController.dueToReceived = item.dueTo
            itemViewController.createdAtReceived = item.createdAt
            itemViewController.place = row
        }
    }
    
    @IBAction func erase(_ unwindSegue: UIStoryboardSegue) {
        if let vc = unwindSegue.source as? ItemViewController {
            self.items.remove(at: vc.place)
            vc.dismiss(animated: true)
        }
    }
    
    @IBAction func cancel(_ unwindSegue:UIStoryboardSegue){
        if let vc = unwindSegue.source as? ItemViewController {
            vc.dismiss(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoListTableView.reloadData()
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
    
    func isMoreRecent(todo1:ToDo, todo2:ToDo) -> Bool{
        return todo1.dueTo < todo2.dueTo
    }
    
    @IBAction func sortTodos(_ sender: Any) {
        self.items = self.items.sorted(by: isMoreRecent)
        todoListTableView.reloadData()
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
    	
}
