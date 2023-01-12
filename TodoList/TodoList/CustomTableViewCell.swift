//
//  CustomTableViewCell.swift
//  TodoList
//
//  Created by user226225 on 1/12/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell{
    @IBOutlet weak var isDone: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
