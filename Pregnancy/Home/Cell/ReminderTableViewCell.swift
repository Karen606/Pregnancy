//
//  ReminderTableViewCell.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        reminderLabel.font = .regular(size: 12)
        dateLabel.font = .regular(size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(reminder: ReminderModel, index: Int) {
        reminderLabel.text = "\(index). \(reminder.name ?? "")"
        dateLabel.text = "\(reminder.date?.toString(format: "dd/MM/yy") ?? "") \(reminder.time?.toString(format: "hh:mm") ?? "")"
    }
    
}
