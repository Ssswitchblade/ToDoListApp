//
//  MyCell.swift
//  ToDoAppRealmProject
//
//  Created by Admin on 11.06.2022.
//

import UIKit

protocol MyCellDelegate {
    func editCell(cell: MyCell)
    func deleteCell(cell: MyCell)
}

class MyCell: UITableViewCell {
    
    var model = Model()
    var delegate:  MyCellDelegate?
    
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var labelCell: UILabel!
    
    //@IBOutlet weak var labelCell: UILabel!
    //@IBOutlet weak var edit: UIButton!
    //@IBOutlet weak var delete: UIButton!
    
    //Actions
    
    @IBAction func editCellBtnTpd(_ sender: UIButton) {
        delegate?.editCell(cell: self)
    }
    @IBAction func deleteCellBtnTpd(_ sender: UIButton) {
        delegate?.deleteCell(cell: self)
    }
    
    
}
