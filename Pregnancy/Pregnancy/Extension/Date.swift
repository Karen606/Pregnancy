//
//  Date.swift
//  Pregnancy
//
//  Created by Karen Khachatryan on 31.10.24.
//

import Foundation

extension Date {
    func toString(format: String = "dd/MM/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func addWeeks(weeks: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.weekOfYear = weeks
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }
    
    func calculateWeeks() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear], from: self, to: Date())
        return components.weekOfYear ?? 0
    }
}
