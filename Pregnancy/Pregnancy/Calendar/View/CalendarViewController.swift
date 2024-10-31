//
//  CalendarViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: BaseButton!
    @IBOutlet weak var datePickerView: ShadowView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindersView: UIView!
    @IBOutlet weak var remindersTableView: UITableView!
    @IBOutlet weak var remindersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        titleLabel.font = .regular(size: 28)
        addButton.titleLabel?.font = .semibold(size: 18)
        addButton.addShadow()
        remindersLabel.font = .regular(size: 20)
        remindersView.layer.borderWidth = 1
        remindersView.layer.borderColor = UIColor.genderBorder.cgColor
        remindersView.layer.cornerRadius = 6

    }

}
