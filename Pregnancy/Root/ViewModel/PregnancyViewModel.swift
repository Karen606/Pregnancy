//
//  PregnancyViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import Foundation

class PregnancyViewModel {
    static let shared = PregnancyViewModel()
    @Published var pregnancyModel = PregnancyModel()
    
    private init() {
        pregnancyModel.menstruation = Date()
        pregnancyModel.birth = Date().addWeeks(weeks: 40)
    }
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.savePregnancy(pregnancyModel: pregnancyModel) { error in
            completion(error)
        }
    }
    
    func clear() {
        pregnancyModel = PregnancyModel()
    }
}
