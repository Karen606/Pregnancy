//
//  ViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class RootViewController: UIViewController {

    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var menstruationDateLabel: UILabel!
    @IBOutlet weak var weekTitleLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var weeksCollectionView: UICollectionView!
    private let datePicker = UIDatePicker()
    private let containerView = UIView()
    private let overlayView = UIView()
    private let viewModel = PregnancyViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        subscribe()
    }
    
    func setupUI() {
        titleLabels.forEach({ $0.font = .regular(size: 12) })
        weekTitleLabel.font = .regular(size: 20)
        nextButton.titleLabel?.font = .medium(size: 24)
        menstruationDateLabel.font = .regular(size: 14)
        birthDateLabel.font = .regular(size: 14)
        nextButton.addShadow()
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 110, height: 110)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        layout.minimumLineSpacing = 7
        weeksCollectionView.collectionViewLayout = layout
        weeksCollectionView.register(UINib(nibName: "WeekCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WeekCollectionViewCell")
        weeksCollectionView.delegate = self
        weeksCollectionView.dataSource = self
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.frame = view.bounds
        overlayView.isHidden = true
        overlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideDatePicker)))
        view.addSubview(overlayView)
        
    }
    
    private func setupDatePicker() {
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        containerView.backgroundColor = .background
        containerView.layer.cornerRadius = 13
        containerView.layer.masksToBounds = true
        containerView.isHidden = true
        containerView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: containerView.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func subscribe() {
        viewModel.$pregnancyModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pregnancyModel in
                guard let self = self else { return }
                self.menstruationDateLabel.text = pregnancyModel.menstruation?.toString()
                self.birthDateLabel.text = pregnancyModel.birth?.toString()
                var week = pregnancyModel.menstruation?.calculateWeeks()
                if (week ?? 0) > 39 { week = 39 }
                self.weeksCollectionView.scrollToItem(at: IndexPath(item: (week ?? 1) - 1, section: 0), at: .left, animated: true)
            }
            .store(in: &cancellables)
    }
    
    @objc func dateChanged() {
        viewModel.pregnancyModel.menstruation = datePicker.date
        viewModel.pregnancyModel.birth = datePicker.date.addWeeks(weeks: 40)
        menstruationDateLabel.text = datePicker.date.toString()
    }
    
    @objc private func hideDatePicker() {
        containerView.isHidden = true
        overlayView.isHidden = true
    }
    
    @IBAction func chooseMenstruationDate(_ sender: UIButton) {
        containerView.isHidden = false
        overlayView.isHidden = false
    }
    
    @IBAction func chooseBirthDate(_ sender: UIButton) {
    }
    
    @IBAction func clickedNext(_ sender: UIButton) {
        self.pushViewController(GenderViewController.self)
    }
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeekCollectionViewCell", for: indexPath) as! WeekCollectionViewCell
        cell.configure(with: indexPath.item + 1)
        return cell
    }
}
