//
//  FoodTableViewCell.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var calloriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        nameLabel.font = .regular(size: 16)
        calloriesLabel.font = .regular(size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(food: FoodModel) {
        nameLabel.text = food.name
        calloriesLabel.text = String(food.callories ?? 0)
    }
    
}
