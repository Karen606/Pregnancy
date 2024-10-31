//
//  HealthTableViewCell.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit

class HealthTableViewCell: UITableViewCell {

    @IBOutlet weak var healthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        healthLabel.font = .regular(size: 16)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(health: HealthModel) {
        healthLabel.text = "\(health.date.toString()) Weight \(health.weight ?? "")kg Pressure: \(health.pressure ?? "")"
    }
    
}
