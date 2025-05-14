//
//  ExerciseTableViewCell.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {

    @IBOutlet weak var exerciseTextField: BaseTextField!
    private var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        exerciseTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        exerciseTextField.text = nil
        index = 0
    }
    
    func configure(exercise: String?, index: Int) {
        self.index = index
        exerciseTextField.text = exercise
    }
}

extension ExerciseTableViewCell: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        HealthFormViewModel.shared.healthModel.exercises[index] = textField.text ?? ""
    }
}
