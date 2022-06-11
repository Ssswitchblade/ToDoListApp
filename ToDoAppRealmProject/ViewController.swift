//
//  ViewController.swift
//  ToDoAppRealmProject
//
//  Created by Admin on 11.06.2022.
//

import UIKit
import RealmSwift
import Realm
class TableViewController: UITableViewController {

    let realm = try! Realm()
    let model = Model()
    var alert = UIAlertController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.loadRealmDataBase()
        
        // try! FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
        print(realm.configuration.fileURL)
        self.tableView.reloadData()
    }
    
    func editCellContext(indexPath: IndexPath) {
        
        var cell = tableView(tableView, cellForRowAt: indexPath) as! MyCell
        alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.addTarget(self, action: #selector(self.textFieldIsNotEmpty(_:)), for: .editingChanged)
            textField.text = cell.labelCell.text
        })
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (createAlert) in
            guard let textFields = self.alert.textFields, textFields.count > 0 else { return }
            guard let text = self.alert.textFields?[0].text else { return }
            
            self.model.updateItem(at: indexPath.row, with: text)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func textFieldIsNotEmpty(_ sender: UITextField) {
        guard let senderText = sender.text, alert.actions.indices.contains(1) else  { return }
        
        let action = alert.actions[1]
        action.isEnabled = senderText.count > 0
    }
 

    @IBAction func addTskBtnTpd(_ sender: Any) {
        alert = UIAlertController(title: "Create New Task", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Put your task here"
            textField.addTarget(self, action: #selector(self.textFieldIsNotEmpty(_:)), for: .editingChanged)
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (creatAlert) in
            
            guard let taskText = self.alert.textFields?[0].text else { return }
            
            self.model.addItem(itemName: taskText)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        present(alert, animated: true, completion: nil)
        addAction.isEnabled = false
    }
    
    
    
   //TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return model.tasks!.count
     }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(UINib(nibName: "MyCell", bundle: nil), forCellReuseIdentifier: "MyCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! MyCell
        cell.delegate = self
        if let task = model.tasks?[indexPath.row] {
            cell.labelCell.text = task.name
            cell.accessoryType = task.isComplited ? .checkmark : .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if model.changeState(at: indexPath.row) == true {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
  /* Еще один метод для удаления ячеек(стандартный UITableView)
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            try! realm.write{
                realm.delete(model.tasks[indexPath.row])
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    */
    
}

extension TableViewController: MyCellDelegate {
    
    func editCell(cell: MyCell) {
        let indexPath = tableView.indexPath(for: cell)
        guard let unwrpIndexPath = indexPath else { return }
        editCellContext(indexPath: unwrpIndexPath)
        self.tableView.reloadData()
    }
    
    func deleteCell(cell: MyCell) {
        let indexPath = tableView.indexPath(for: cell)
        guard let unwrpindexPath = indexPath else { return }
        model.removeItem(at: unwrpindexPath.row)
        self.tableView.reloadData()
        
    }
    
    
    
}
