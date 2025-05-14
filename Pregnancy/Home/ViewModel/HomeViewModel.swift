//
//  HomeViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    @Published var reminders: [ReminderModel] = []
    private init() {}
    
    func fetchPregrancy(completion: @escaping (PregnancyModel?, Error?) -> Void) {
        CoreDataManager.shared.fetchPregnancy(completion: completion)
    }
    
    func fetchReminders() {
        CoreDataManager.shared.fetchReminders { [weak self] reminders, _ in
            guard let self = self else { return }
            self.reminders = reminders
        }
    }
}
