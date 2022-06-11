//
//  Object.swift
//  ToDoAppRealmProject
//
//  Created by Admin on 11.06.2022.
//

import Foundation
import Realm
import RealmSwift

class Task: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var isComplited: Bool = false
    
}
