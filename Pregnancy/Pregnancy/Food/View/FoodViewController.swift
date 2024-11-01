//
//  FoodViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class FoodViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: BaseButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var datePickerView: ShadowView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var foodsTableView: UITableView!
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var recamendationsButton: BaseButton!
    @IBOutlet weak var recamendationsCollectionView: UICollectionView!
    private let viewModel = FoodViewModel.shared
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
        dateButton.titleLabel?.font = .medium(size: 22)
        recamendationsButton.titleLabel?.font = .regular(size: 16)
        totalCaloriesLabel.font = .regular(size: 16)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        foodsTableView.delegate = self
        foodsTableView.dataSource = self
        foodsTableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 74)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.minimumLineSpacing = 15
        recamendationsCollectionView.collectionViewLayout = layout
        recamendationsCollectionView.register(UINib(nibName: "RecamendationCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RecamendationCollectionViewCell")
        recamendationsCollectionView.delegate = self
        recamendationsCollectionView.dataSource = self
    }
    
    func subscribe() {
        viewModel.$foods
            .receive(on: DispatchQueue.main)
            .sink { [weak self] foods in
                guard let self = self else { return }
                let totalCallories = foods.reduce(0) { sum, food in
                    sum + (food.callories ?? 0)
                }
                self.totalCaloriesLabel.isHidden = !(totalCallories > 0)
                self.totalCaloriesLabel.text = "The total number of calories = \(totalCallories)"
                self.foodsTableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$date
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else { return }
                dateButton.setTitle(date.toString(format: "d MMMM"), for: .normal)
            }
            .store(in: &cancellables)
    }
    
    @objc func dateChanged() {
        datePickerView.isHidden = true
        dateButton.isSelected = false
        viewModel.setDate(date: datePicker.date)
    }
    
    @IBAction func chooseDate(_ sender: UIButton) {
        datePickerView.isHidden.toggle()
        dateButton.isSelected.toggle()
    }
    
    @IBAction func clickedAddFood(_ sender: UIButton) {
        let foodFormVC = FoodFormViewController(nibName: "FoodFormViewController", bundle: nil)
        foodFormVC.completion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetchData()
        }
        foodFormVC.modalPresentationStyle = .overFullScreen
        self.present(foodFormVC, animated: false)
    }
}

extension FoodViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.foods.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoodTableViewCell", for: indexPath) as! FoodTableViewCell
        cell.configure(food: viewModel.foods[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
}

extension FoodViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recomendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecamendationCollectionViewCell", for: indexPath) as! RecamendationCollectionViewCell
        cell.configure(title: viewModel.recomendations[indexPath.item])
        return cell
    }
}
