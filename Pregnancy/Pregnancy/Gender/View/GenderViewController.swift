//
//  GenderViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class GenderViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var genderButtons: [UIButton]!
    @IBOutlet weak var nextButton: BaseButton!
    private let viewModel = PregnancyViewModel.shared
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        titleLabel.font = .regular(size: 20)
        genderButtons.forEach({ $0.titleLabel?.font = .regular(size: 20); $0.layer.borderWidth = 1.3 })
        nextButton.titleLabel?.font = .medium(size: 24)
    }
    
    func subscribe() {
        viewModel.$pregnancyModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pregnancyModel in
                guard let self = self else { return }
                self.nextButton.isEnabled = (pregnancyModel.birth != nil && pregnancyModel.menstruation != nil && pregnancyModel.gender.checkValidation())
                self.selectGender(gender: pregnancyModel.gender)
            }
            .store(in: &cancellables)
    }
    
    func selectGender(gender: String?) {
        genderButtons.forEach({ $0.isSelected = false })
        switch gender {
        case "Boy":
            genderButtons[0].isSelected = true
        case "Girl":
            genderButtons[1].isSelected = true
        case "I don’t know":
            genderButtons[2].isSelected = true
        default:
            break
        }
    }

    @IBAction func chooseBoy(_ sender: UIButton) {
        viewModel.pregnancyModel.gender = "Boy"
    }
    
    @IBAction func chooseGirl(_ sender: UIButton) {
        viewModel.pregnancyModel.gender = "Girl"
    }
    
    @IBAction func chooseDontKnow(_ sender: UIButton) {
        viewModel.pregnancyModel.gender = "I don’t know"
    }
    
    @IBAction func clickedNext(_ sender: BaseButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                
            }
        }
    }
}
