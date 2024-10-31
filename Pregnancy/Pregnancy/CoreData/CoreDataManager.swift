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
    
//    func fetchParties(completion: @escaping ([PartyModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var partyModels: [PartyModel] = []
//                for result in results {
//                    let partyModel = PartyModel(id: result.id, name: result.name, location: result.location, theme: result.theme, date: result.date)
//                    partyModels.append(partyModel)
//                }
//                completion(partyModels, nil)
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
    
//    func saveGuest(guestModel: GuestModel, completion: @escaping (Error?) -> Void) {
//        let id = guestModel.id ?? UUID()
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Guest> = Guest.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                let guest: Guest
//
//                if let existingGuest = results.first {
//                    guest = existingGuest
//                } else {
//                    guest = Guest(context: backgroundContext)
//                    guest.id = id
//                }
//                guest.name = guestModel.name
//                guest.phone = guestModel.phone
//                guest.email = guestModel.email
//                guest.photo = guestModel.photo
//                guest.isConfirmed = guestModel.isConfirmed
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchGuests(completion: @escaping ([GuestModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Guest> = Guest.fetchRequest()
//            
//            do {
//                let results = try backgroundContext.fetch(fetchRequest)
//                var guestsModel: [GuestModel] = []
//                for result in results {
//                    let guestModel = GuestModel(id: result.id, photo: result.photo, name: result.name, phone: result.phone, email: result.email, isConfirmed: result.isConfirmed)
//                    guestsModel.append(guestModel)
//                }
//                completion(guestsModel, nil)
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
//    
////    func addGuestToParty(guestModel: GuestModel, partyID: UUID, completion: @escaping (Error?) -> Void) {
////        let backgroundContext = persistentContainer.newBackgroundContext()
////        backgroundContext.perform {
////            let fetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
////            fetchRequest.predicate = NSPredicate(format: "id == %@", partyID as CVarArg)
////
////            do {
////                let results = try backgroundContext.fetch(fetchRequest)
////                if let party = results.first {
////                    if (party.guests ?? []).contains(where: { $0.id == guestModel.id }) {
////                        completion(nil)
////                    } else {
////                        let guest = Guest(context: backgroundContext)
////                        guest.id = guestModel.id
////                        guest.name = guestModel.name
////                        guest.phone = guestModel.phone
////                        guest.email = guestModel.email
////                        guest.photo = guestModel.photo
////                        guest.isConfirmed = guestModel.isConfirmed
////                        party.guests?.append(guest)
////                    }
////                }
////                try backgroundContext.save()
////                DispatchQueue.main.async {
////                    completion(nil)
////                }
////            } catch {
////                DispatchQueue.main.async {
////                    completion(error)
////                }
////            }
////        }
////    }
//    
//    func addGuestToParty(guestModel: GuestModel, partyID: UUID, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let partyFetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//            partyFetchRequest.predicate = NSPredicate(format: "id == %@", partyID as CVarArg)
//
//            do {
//                guard let party = try backgroundContext.fetch(partyFetchRequest).first else {
//                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Party not found"])
//                }
//
//                let guestFetchRequest: NSFetchRequest<Guest> = Guest.fetchRequest()
//                guestFetchRequest.predicate = NSPredicate(format: "id == %@", guestModel.id as CVarArg? ?? UUID() as CVarArg)
//
//                let guest: Guest
//                if let existingGuest = try backgroundContext.fetch(guestFetchRequest).first {
//                    guest = existingGuest
//                } else {
//                    guest = Guest(context: backgroundContext)
//                    guest.id = guestModel.id ?? UUID()
//                }
//
//                guest.name = guestModel.name
//                guest.phone = guestModel.phone
//                guest.email = guestModel.email
//                guest.photo = guestModel.photo
//                guest.isConfirmed = guestModel.isConfirmed
//
//                party.addToGuests(guest)
//
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchGuests(forPartyId partyId: UUID, completion: @escaping ([GuestModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "id == %@", partyId as CVarArg)
//            fetchRequest.relationshipKeyPathsForPrefetching = ["guests"]
//
//            do {
//                guard let party = try backgroundContext.fetch(fetchRequest).first,
//                      let guests = party.guests?.allObjects as? [Guest] else {
//                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Party or Guests not found"])
//                }
//
//                let guestModels = guests.map { guest in
//                    GuestModel(
//                        id: guest.id,
//                        photo: guest.photo,
//                        name: guest.name,
//                        phone: guest.phone,
//                        email: guest.email,
//                        isConfirmed: guest.isConfirmed
//                    )
//                }
//
//                DispatchQueue.main.async {
//                    completion(guestModels, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }
//    
//    func updateGuestConfirmationStatus(partyID: UUID, guestID: UUID, isConfirmed: Bool, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let partyFetchRequest: NSFetchRequest<Party> = Party.fetchRequest()
//            partyFetchRequest.predicate = NSPredicate(format: "id == %@", partyID as CVarArg)
//
//            do {
//                guard let party = try backgroundContext.fetch(partyFetchRequest).first else {
//                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Party not found"])
//                }
//
//                let guestFetchRequest: NSFetchRequest<Guest> = Guest.fetchRequest()
//                guestFetchRequest.predicate = NSPredicate(format: "id == %@ AND party == %@", guestID as CVarArg, party)
//
//                guard let guest = try backgroundContext.fetch(guestFetchRequest).first else {
//                    throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "Guest not found in the selected party"])
//                }
//
//                guest.isConfirmed = isConfirmed
//
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//
//    func saveCoctail(coctailModel: CoctailModel, completion: @escaping (Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let coctailFetchRequest: NSFetchRequest<Coctail> = Coctail.fetchRequest()
//            let id = coctailModel.id ?? UUID()
//            coctailFetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
//
//            do {
//                let results = try backgroundContext.fetch(coctailFetchRequest)
//                let coctail: Coctail
//
//                if let existingCoctail = results.first {
//                    coctail = existingCoctail
//                } else {
//                    coctail = Coctail(context: backgroundContext)
//                    coctail.id = id
//                }
//
//                coctail.name = coctailModel.name
//                coctail.photo = coctailModel.photo
//                coctail.descriptionPreparation = coctailModel.descriptionPreparation
//
//                if let existingCompositions = coctail.compositions as? Set<Composition> {
//                    for composition in existingCompositions {
//                        backgroundContext.delete(composition)
//                    }
//                }
//
//                if let compositions = coctailModel.compositions {
//                    for compositionModel in compositions {
//                        let composition = Composition(context: backgroundContext)
//                        composition.name = compositionModel.name
//                        composition.value = compositionModel.value
//                        composition.coctail = coctail
//                        coctail.addToCompositions(composition)
//                    }
//                }
//
//                try backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
//    
//    func fetchCoctails(completion: @escaping ([CoctailModel], Error?) -> Void) {
//        let backgroundContext = persistentContainer.newBackgroundContext()
//        backgroundContext.perform {
//            let fetchRequest: NSFetchRequest<Coctail> = Coctail.fetchRequest()
//
//            do {
//                let coctails = try backgroundContext.fetch(fetchRequest)
//                let coctailModels = coctails.map { coctail in
//                    let compositions = (coctail.compositions as? Set<Composition>)?.map { composition in
//                        CompositionModel(name: composition.name, value: composition.value)
//                    }
//
//                    return CoctailModel(
//                        id: coctail.id,
//                        name: coctail.name,
//                        photo: coctail.photo,
//                        compositions: compositions,
//                        descriptionPreparation: coctail.descriptionPreparation
//                    )
//                }
//
//                DispatchQueue.main.async {
//                    completion(coctailModels, nil)
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion([], error)
//                }
//            }
//        }
//    }



}
