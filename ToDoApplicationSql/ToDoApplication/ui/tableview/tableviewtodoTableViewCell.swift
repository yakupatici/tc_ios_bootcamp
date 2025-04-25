//
//  tableviewtodoTableViewCell.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 19.04.2025.
//

import UIKit

class tableviewtodoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var todoName: UILabel!
    
    
    @IBOutlet weak var todoId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
