//
//  ToDo.swift
//  TodoList
//
//  Created by user226225 on 12/24/22.
//

import Foundation
class ToDo{
    var name = ""
    var desc = ""
    var createdAt = Date()
    var dueTo = Date()
    
    func getDesc() -> String{
        return self.desc
    }
    
    init(name:String, desc:String, dueTo:Date){
        self.name = name
        self.desc = desc
        self.createdAt = Date()
        self.dueTo = dueTo
    }
}
