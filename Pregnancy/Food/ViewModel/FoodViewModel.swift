//
//  FoodViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import Foundation

class FoodViewModel {
    static let shared = FoodViewModel()
    @Published var foods: [FoodModel] = []
    private var data: [FoodModel] = []
    @Published var date = Date()
    let recomendations = ["Drink water", "Healthy food", "Limit salt and sugar"]
    
    private init() {}
    func fetchData() {
        CoreDataManager.shared.fetchFoods { [weak self] foods, _ in
            guard let self = self else { return }
            self.data = foods
            self.filterFoods()
        }
    }
    
    func filterFoods() {
        self.foods = self.data.filter({ $0.date?.stripTime() == self.date.stripTime() })
    }
    
    func setDate(date: Date) {
        self.date = date
        filterFoods()
    }
}
