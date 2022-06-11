//
//  Model.swift
//  ToDoAppRealmProject
//
//  Created by Admin on 11.06.2022.
//

import Foundation
import Realm
import RealmSwift

protocol ModelProtocol {
    
    func addItem(itemName: String, isCompleted: Bool )
    func removeItem(at index: Int)
    func updateItem(at index: Int, with string: String)
    func changeState(at item: Int) -> Bool
    func loadRealmDataBase()
}

class Model: ModelProtocol {

    let realm = try! Realm()
    
    var tasks: Results<Task>!
        
    func loadRealmDataBase() {
        tasks = realm.objects(Task.self)
    }
   
    //Обновить задачу
    func updateItem(at index: Int, with string: String) {
        try! realm.write{
            tasks[index].name = string
        }
    }
    //Поменять готовность задачи
    func changeState(at item: Int) -> Bool {
        try! realm.write{
            tasks[item].isComplited = !tasks![item].isComplited
        }
        return tasks[item].isComplited
    }
    
    //Добавление новой заметки
      func addItem(itemName: String, isCompleted: Bool = false) {
         let task = Task()
          task.name = itemName
          task.isComplited = isCompleted
          try! realm.write{
              realm.add(task)
              loadRealmDataBase()
          }
      }
    
    //Удаление задачи
    func removeItem(at index: Int) {
        try! realm.write{
            realm.delete(tasks[index])
        }
    }
}
