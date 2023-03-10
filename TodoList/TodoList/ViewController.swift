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
    var itemsFiltered = [ToDo]()
    var placeToErase = 0
    var category = 0
    
    var today = [ToDo]()
    var tomorrow = [ToDo]()
    var thisWeek = [ToDo]()
    var later = [ToDo]()
    
    @IBOutlet weak var todoListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationController?.delegate = self
        self.itemsFiltered = self.items
        for item in items{
            if Calendar.current.isDateInToday(item.dueTo){
                today.append(item)
                thisWeek.append(item)
            }
            else if Calendar.current.isDateInTomorrow(item.dueTo){
                tomorrow.append(item)
                thisWeek.append(item)
            }
            else{
                let startOfNow = Calendar.current.startOfDay(for: Date())
                let startOfTimeStamp = Calendar.current.startOfDay(for: item.dueTo)
                let components = Calendar.current.dateComponents([.day, .weekday], from: startOfNow, to: startOfTimeStamp)
                let day = components.day!-components.weekday!
                if  day<8{
                    thisWeek.append(item)
                }
                else{
                    later.append(item)
                }
            }
        }
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
                self.itemsFiltered.append(newToDo)
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
        showFiltered()
    }
    
    func showFiltered(){
        self.itemsFiltered = self.items
        if !searchBar.text!.isEmpty {
            self.itemsFiltered = self.itemsFiltered.filter { (todo) -> Bool in
                return todo.name.lowercased().contains(searchBar.text!.lowercased())
            }
        }
        todoListTableView.reloadData()
    }
    
    @IBAction func changeValue(_ sender: Any) {
        guard let isDone = sender as? UISwitch else { return }
        //On r??cupere la cellule qui contient le switch qui ?? chang?? de valeur
        guard let cell = isDone.superview?.superview as? UITableViewCell else { return }
        guard let indexPath = todoListTableView.indexPath(for: cell) else { return }
        self.items[indexPath.row].state = isDone.isOn
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsFiltered.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell
        cell?.textLabel!.text = itemsFiltered[indexPath.row].name
        cell?.isDone.isOn = itemsFiltered[indexPath.row].state
        return cell! 
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? CategoryViewController{
            vc.categories[self.category].todos = self.itemsFiltered
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.showFiltered()
       }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
    }
    	
}
