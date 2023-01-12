//
//  ToDoList.swift
//  TodoList
//
//  Created by user226225 on 1/10/23.
//

import Foundation
class ToDoList{
    var name = ""
    var todos = [ToDo]()
    init(name:String, todos:[ToDo]){
        self.name = name
        self.todos = todos
    }
}
