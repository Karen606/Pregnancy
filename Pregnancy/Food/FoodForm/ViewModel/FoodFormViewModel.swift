//
//  FoodFormViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import Foundation

class FoodFormViewModel {
    static let shared = FoodFormViewModel()
    @Published var foodModel = FoodModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveFood(foodModel: foodModel, completion: completion)
    }
    
    func clear() {
        foodModel = FoodModel(id: UUID())
    }
}
