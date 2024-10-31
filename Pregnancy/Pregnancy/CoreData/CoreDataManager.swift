//
//  CoreDataManager.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Pregnancy")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func savePregnancy(pregnancyModel: PregnancyModel, completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Pregnancy> = Pregnancy.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let pregnancy: Pregnancy
                if let existingPregnancy = results.first {
                    pregnancy = existingPregnancy
                } else {
                    pregnancy = Pregnancy(context: backgroundContext)
                }
                pregnancy.birth = pregnancyModel.birth
                pregnancy.menstruation = pregnancyModel.menstruation
                pregnancy.gender = pregnancyModel.gender
                
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchPregnancy(completion: @escaping (PregnancyModel?, Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Pregnancy> = Pregnancy.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if let pregrancy = results.first {
                    let pregrancyModel = PregnancyModel(menstruation: pregrancy.menstruation, birth: pregrancy.birth, gender: pregrancy.gender)
                    DispatchQueue.main.async {
                        completion(pregrancyModel, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil, nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
    
    func saveReminder(reminderModel: ReminderModel, completion: @escaping (Error?) -> Void) {
        let id = reminderModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let reminder: Reminder

                if let existingReminder = results.first {
                    reminder = existingReminder
                } else {
                    reminder = Reminder(context: backgroundContext)
                    reminder.id = id
                }
                reminder.name = reminderModel.name
                reminder.time = reminderModel.time
                reminder.date = reminderModel.date
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchReminders(completion: @escaping ([ReminderModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Reminder> = Reminder.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var remindersModel: [ReminderModel] = []
                for result in results {
                    let reminderModel = ReminderModel(id: result.id, name: result.name, date: result.date, time: result.time)
                    remindersModel.append(reminderModel)
                }
                completion(remindersModel, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
    func saveHealth(healthModel: HealthModel, completion: @escaping (Error?) -> Void) {
        let id = healthModel.id ?? UUID()
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                let health: Health

                if let existingHealth = results.first {
                    health = existingHealth
                } else {
                    health = Health(context: backgroundContext)
                    health.id = id
                }
                health.status = healthModel.status
                health.weight = healthModel.weight
                health.pressure = healthModel.pressure
                health.exercises = healthModel.exercises
                health.date = healthModel.date
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
    
    func fetchHealths(completion: @escaping ([HealthModel], Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<Health> = Health.fetchRequest()
            
            do {
                let results = try backgroundContext.fetch(fetchRequest)
                var healthModels: [HealthModel] = []
                for result in results {
                    let healthModel = HealthModel(id: result.id, status: result.status, weight: result.weight, pressure: result.pressure, exercises: result.exercises ?? [], date: result.date ?? Date())
                    healthModels.append(healthModel)
                }
                completion(healthModels, nil)
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
    }
    
}
