//
//  GenderButton.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit

class GenderButton: UIButton {
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderColor = isSelected ? UIColor.genderBorder.cgColor : UIColor.clear.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
