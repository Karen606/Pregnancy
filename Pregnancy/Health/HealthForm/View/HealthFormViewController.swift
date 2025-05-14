//
//  HealthFormViewController.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit
import Combine

class HealthFormViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var titleLabels: [UILabel]!
    @IBOutlet weak var statusTextField: BaseTextField!
    @IBOutlet weak var weightTextField: BaseTextField!
    @IBOutlet weak var presureTextField: BaseTextField!
    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var addExerciseButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    private let viewModel = HealthFormViewModel.shared
    private var cancellables: Set<AnyCancellable> = []
    var completion: (() -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        exercisesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        registerKeyboardNotifications()
        setupUI()
        subscribe()
    }
    
    func setupUI() {
        self.view.backgroundColor = .background.withAlphaComponent(0.4)
        titleLabels.forEach({ $0.font = .medium(size: 16) })
        saveButton.titleLabel?.font = .montserratMedium(size: 14)
        cancelButton.titleLabel?.font = .montserratMedium(size: 14)
        statusTextField.delegate = self
        weightTextField.delegate = self
        presureTextField.delegate = self
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        exercisesTableView.register(UINib(nibName: "ExerciseTableViewCell", bundle: nil), forCellReuseIdentifier: "ExerciseTableViewCell")
    }
    
    func subscribe() {
        viewModel.$healthModel
            .receive(on: DispatchQueue.main)
            .sink { [weak self] health in
                guard let self = self else { return }
                self.saveButton.isEnabled = (health.status.checkValidation() && health.weight.checkValidation() && health.pressure.checkValidation())
                if (health.exercises.count) != viewModel.previousExercisesCount {
                    self.exercisesTableView.reloadData()
                    viewModel.previousExercisesCount = health.exercises.count
                }
            }
            .store(in: &cancellables)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if let newSize = change?[.newKey] as? CGSize {
                updateTableViewHeight(newSize: newSize)
            }
        }
    }
    
    private func updateTableViewHeight(newSize: CGSize) {
        tableViewHeightConst.constant = newSize.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        handleTap()
    }
    
    @IBAction func clickedAddExercise(_ sender: UIButton) {
        viewModel.addExercise()
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
                self.completion?()
                self.dismiss(animated: false)
            }
        }
    }
    
    deinit {
        viewModel.clear()
    }
}

extension HealthFormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.healthModel.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExerciseTableViewCell", for: indexPath) as! ExerciseTableViewCell
        cell.configure(exercise: viewModel.healthModel.exercises[indexPath.row], index: indexPath.row)
        return cell
    }
}

extension HealthFormViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case statusTextField:
            viewModel.healthModel.status = textField.text
        case weightTextField:
            viewModel.healthModel.weight = textField.text
        case presureTextField:
            viewModel.healthModel.pressure = textField.text
        default:
            break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == weightTextField {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

extension HealthFormViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(HealthFormViewController.keyboardNotification(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                scrollView.contentInset = .zero
            } else {
                let height: CGFloat = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)!.size.height
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
            }
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}
