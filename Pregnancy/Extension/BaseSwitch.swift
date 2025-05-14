//
//  BaseSwitch.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit

class BaseSwitch: UISwitch {
    override var isOn: Bool {
        didSet {
            self.thumbTintColor = isOn ? .baseGreen : .baseOrange
        }
    }
}
