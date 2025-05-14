//
//  EventFormViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import Foundation

class EventFormViewModel {
    static let shared = EventFormViewModel()
    @Published var reminderModel = ReminderModel(id: UUID())
    private init() {}
    
    func save(completion: @escaping (Error?) -> Void) {
        CoreDataManager.shared.saveReminder(reminderModel: reminderModel, completion: completion)
    }
    
    func clear() {
        reminderModel = ReminderModel(id: UUID())
    }
}
