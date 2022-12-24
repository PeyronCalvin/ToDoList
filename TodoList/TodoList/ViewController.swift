//
//  ViewController.swift
//  TodoList
//
//  Created by user226225 on 12/24/22.
//

import UIKit

class ViewController: UIViewController {

    var items = [ToDo]()
    @IBOutlet weak var todoListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        var nameField = UITextField()
        var descField = UITextField()
        
        let alert = UIAlertController(title: "add new item", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default){(save) in
            let newToDo = ToDo(name: nameField.text!, desc: descField.text!)
            self.items.append(newToDo)
            self.todoListTableView.reloadData()
        }
        
        alert.addTextField{(text) in
            nameField = text
            nameField.placeholder = "ToDo name"
        }
        alert.addTextField{(text) in
            descField = text
            descField.placeholder = "ToDo desc"
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
