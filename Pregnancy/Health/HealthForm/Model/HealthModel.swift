//
//  HealthModel.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 01.11.24.
//

import Foundation

struct HealthModel {
    var id: UUID?
    var status: String?
    var weight: String?
    var pressure: String?
    var exercises: [String] = []
    var date = Date()
}
