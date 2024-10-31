//
//  HomeViewModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()
    private init() {}
    
    func fetchPregrancy(completion: @escaping (PregnancyModel?, Error?) -> Void) {
        CoreDataManager.shared.fetchPregnancy(completion: completion)
    }
}
