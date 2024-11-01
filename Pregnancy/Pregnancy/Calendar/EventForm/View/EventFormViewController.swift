//
//  EventFormViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import UIKit
import Combine

class EventFormViewController: UIViewController {
    
    @IBOutlet weak var contentView: ShadowView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var nameTextField: BaseTextField!
    @IBOutlet weak var dateTextField: BaseTextField!
    @IBOutlet weak var timeTextField: BaseTextField!
    private let datePicker = UIDatePicker()
    private let timePicker = UIDatePicker()
    private let viewModel = EventFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        self.view.backgroundColor = .background.withAlphaComponent(0.4)
        titleLabel.font = .regular(size: 20)
        titleLabels.forEach({ $0.font = .montserratMedium(size: 14) })
        cancelButton.titleLabel?.font = .montserratMedium(size: 11)
        saveButton.titleLabel?.font = .bold(size: 11)
        saveButton.addShadow()
        nameTextField.delegate = self
        dateTextField.delegate = self
        timeTextField.delegate = self
        dateTextField.setupRightViewIcon(.downIcon, size: CGSize(width: 40, height: 40))
        timeTextField.setupRightViewIcon(.downIcon, size: CGSize(width: 40, height: 40))
        datePicker.locale = NSLocale.current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        timePicker.locale = NSLocale.current
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        timeTextField.inputView = timePicker
    }
    
    func subscribe() {
        viewModel.$reminderModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reminder in
                guard let self = self else { return }
                self.saveButton.isEnabled = (reminder.date != nil && reminder.time != nil && reminder.name.checkValidation())
            }
            .store(in: &cancellables)
    }
    
    @objc func dateChanged() {
        viewModel.reminderModel.date = datePicker.date
        dateTextField.text = datePicker.date.toString()
    }
    
    @objc func timeChanged() {
        viewModel.reminderModel.time = timePicker.date
        timeTextField.text = timePicker.date.toString(format: "hh:mm")
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func clickedCancel(_ sender: UIButton) {
        self.dismiss(animated: false)
    }
    
    @IBAction func clickedSave(_ sender: UIButton) {
        viewModel.save { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.showErrorAlert(message: error.localizedDescription)
            } else {
                let date = viewModel.reminderModel.date?.setTime(time: viewModel.reminderModel.time ?? Date())
                NotificationManager.shared.scheduleNotification(for: date?.notifyDate() ?? Date(), title: viewModel.reminderModel.name ?? "", body: date?.toString(format: "dd/MM/yy hh:mm") ?? "")
                self.completion?()
                self.dismiss(animated: false)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension EventFormViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField == nameTextField
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == nameTextField {
            viewModel.reminderModel.name = textField.text
        }
    }
}
