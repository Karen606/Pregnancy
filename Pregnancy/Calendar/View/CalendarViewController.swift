//
//  CalendarViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class CalendarViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: BaseButton!
    @IBOutlet weak var datePickerView: ShadowView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var remindersView: UIView!
    @IBOutlet weak var remindersTableView: UITableView!
    @IBOutlet weak var remindersLabel: UILabel!
    private let viewModel = CalendarViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        viewModel.fetchData()
    }
    
    func setupUI() {
        titleLabel.font = .regular(size: 28)
        addButton.titleLabel?.font = .semibold(size: 18)
        addButton.addShadow()
        remindersLabel.font = .regular(size: 20)
        remindersView.layer.borderWidth = 1
        remindersView.layer.borderColor = UIColor.genderBorder.cgColor
        remindersView.layer.cornerRadius = 6
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        remindersTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReminderTableViewCell")
    }
    
    func subscribe() {
        viewModel.$reminders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminders in
                guard let self = self else { return }
                self.remindersTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @IBAction func clickedAdd(_ sender: UIButton) {
        let eventFormVC = EventFormViewController(nibName: "EventFormViewController", bundle: nil)
        eventFormVC.modalPresentationStyle = .overFullScreen
        eventFormVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        self.tabBarController?.present(eventFormVC, animated: false)
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
        cell.configure(reminder: viewModel.reminders[indexPath.row], index: indexPath.row + 1)
        return cell
    }
}
