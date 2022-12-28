//
//  ItemViewController.swift
//  TodoList
//
//  Created by user226225 on 12/24/22.
//

import UIKit

class ItemViewController: UIViewController {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dueToLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    var nameReceived = ""
    var descReceived = ""
    var dueToReceived = Date()
    var dueToFormatter = DateFormatter()
    var dueToString = ""
    var createdAtReceived = Date()
    var createdAtFormatter = DateFormatter()
    var createdAtString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = nameReceived
        descLabel.text = descReceived
        dueToFormatter.dateFormat = "yyyy-MM-dd"
        dueToString = dueToFormatter.string(from: dueToReceived)
        dueToLabel.text = "Due to: " + dueToString
        createdAtFormatter.dateFormat = "yyyy-MM-dd"
        createdAtString = createdAtFormatter.string(from: createdAtReceived)
        createdAtLabel.text = "Created at: " + createdAtString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
