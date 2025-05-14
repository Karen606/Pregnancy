//
//  CalendarViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import Foundation

class CalendarViewModel {
    static let shared = CalendarViewModel()
    @Published var reminders: [ReminderModel] = []
    private init() {}
    
    func fetchData() {
        CoreDataManager.shared.fetchReminders { [weak self] reminders, _ in
            guard let self = self else { return }
            self.reminders = reminders
        }
    }
    
    func clear() {
        reminders = []
    }
}
