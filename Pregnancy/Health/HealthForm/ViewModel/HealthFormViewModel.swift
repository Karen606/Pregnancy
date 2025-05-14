//
//  HealthFormViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import Foundation

class HealthFormViewModel {
    static let shared = HealthFormViewModel()
    @Published var healthModel = HealthModel(id: UUID(), date: Date())
    var previousExercisesCount: Int = 0

    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        healthModel.exercises.removeAll(where: { !$0.checkValidation()})
        CoreDataManager.shared.saveHealth(healthModel: healthModel, completion: completion)
    }
    
    func addExercise() {
        healthModel.exercises.append("")
    }
    
    func clear() {
        healthModel = HealthModel(id: UUID(), date: Date())
        previousExercisesCount = 0
    }
}
