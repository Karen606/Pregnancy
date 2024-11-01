//
//  FoodFormViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit
import Combine

class FoodFormViewController: UIViewController {
    
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var calloriesTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    private let datePicker = UIDatePicker()
    private let viewModel = FoodFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        self.view.backgroundColor = .background.withAlphaComponent(0.4)
        titleLabels.forEach({ $0.font = .medium(size: 16) })
        saveButton.titleLabel?.font = .montserratMedium(size: 14)
        cancelButton.titleLabel?.font = .montserratMedium(size: 14)
        dateTextField.setupRightViewIcon(.downIcon, size: CGSize(width: 40, height: 40))
        nameTextField.delegate = self
        calloriesTextField.delegate = self
        dateTextField.delegate = self
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
    }
    
    func subscribe() {
        viewModel.$foodModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] food in
                guard let self = self else { return }
                self.saveButton.isEnabled = ((food.date != nil) && (food.name.checkValidation()) && (food.callories != nil))
            }
            .store(in: &cancellables)
    }
    
    @objc func dateChanged() {
        viewModel.foodModel.date = datePicker.date
        dateTextField.text = datePicker.date.toString(format: "dd/MM/yy hh:mm")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.handleTap()
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                self.completion?()
                self.dismiss(animated: false)
            }
        }
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    deinit {
        viewModel.clear()
    }
}

extension FoodFormViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.foodModel.name = textField.text
        } else if textField == calloriesTextField {
            viewModel.foodModel.callories = Int(textField.text ?? "")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == calloriesTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        } else if textField == dateTextField {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
