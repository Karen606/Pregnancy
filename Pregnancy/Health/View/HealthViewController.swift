//
//  HealthViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class HealthViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: BaseButton!
    @IBOutlet weak var healthTableView: UITableView!
    private let viewModel = HealthViewModel.shared
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
        healthTableView.delegate = self
        healthTableView.dataSource = self
        healthTableView.register(UINib(nibName: "HealthTableViewCell", bundle: nil), forCellReuseIdentifier: "HealthTableViewCell")
    }
    
    func subscribe() {
        viewModel.$healths
            .receive(on: DispatchQueue.main)
            .sink { [weak self] healths in
                guard let self = self else { return }
                self.healthTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @IBAction func clickedAddHealth(_ sender: UIButton) {
        let healthFormVC = HealthFormViewController(nibName: "HealthFormViewController", bundle: nil)
        healthFormVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        healthFormVC.modalPresentationStyle = .overFullScreen
        self.tabBarController?.present(healthFormVC, animated: false)
    }
}

extension HealthViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.healths.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthTableViewCell", for: indexPath) as! HealthTableViewCell
        cell.configure(health: viewModel.healths[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
}
