//
//  WeekCollectionViewCell.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weekLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        weekLabel.font = .regular(size: 64)
    }
    
    func configure(with index: Int) {
        self.weekLabel.text = "\(index)"
    }
}
