//
//  RecamendationCollectionViewCell.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit

class RecamendationCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = .regular(size: 12)
        titleLabel.layer.cornerRadius = 16
        titleLabel.layer.borderWidth = 1
        titleLabel.layer.borderColor = UIColor.baseOrange.cgColor
        titleLabel.layer.masksToBounds = true
    }

    func configure(title: String?) {
        titleLabel.text = title
    }
}
