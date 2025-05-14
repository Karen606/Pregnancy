//
//  HealthViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import Foundation

class HealthViewModel {
    static let shared = HealthViewModel()
    @Published var healths: [HealthModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchHealths { [weak self] healths, _ in
            guard let self = self else { return }
            self.healths = healths
        }
    }
    
    func clear() {
        healths = []
    }
}
