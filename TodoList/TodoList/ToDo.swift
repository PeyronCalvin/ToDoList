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
    
    func getDesc() -> String{
        return self.desc
    }
    
    init(name:String, desc:String){
        self.name = name
        self.desc = desc
    }
}
