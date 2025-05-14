//
//  HomeViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    @IBOutlet var generalInfoViews: [UIView]!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var termLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var remaindersLabel: UILabel!
    @IBOutlet weak var remindersView: UIView!
    @IBOutlet weak var remindersTableView: UITableView!
    private let viewModel = HomeViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchReminders()
    }
    
    func setupUI() {
        for view in generalInfoViews {
            view.layer.borderColor = UIColor.baseOrange.cgColor
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 16
        }
        
        titleLabels.forEach({ $0.font = .regular(size: 14) })
        dateLabel.font = .regular(size: 16)
        termLabel.font = .regular(size: 16)
        genderLabel.font = .regular(size: 16)
        remaindersLabel.font = .regular(size: 20)
        remindersView.layer.borderWidth = 1
        remindersView.layer.borderColor = UIColor.genderBorder.cgColor
        remindersView.layer.cornerRadius = 6
        remindersTableView.delegate = self
        remindersTableView.dataSource = self
        remindersTableView.register(UINib(nibName: "ReminderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReminderTableViewCell")
    }
    
    func fetchData() {
        viewModel.fetchPregrancy { [weak self] pregnancyModel, _ in
            guard let self = self else { return }
            self.dateLabel.text = pregnancyModel?.menstruation?.toString(format: "dd/MM")
            self.termLabel.text = "\(pregnancyModel?.menstruation?.calculateWeeks() ?? 1) week"
            self.genderLabel.text = pregnancyModel?.gender
        }
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
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
        cell.configure(reminder: viewModel.reminders[indexPath.row], index: indexPath.row + 1)
        return cell
    }
}
