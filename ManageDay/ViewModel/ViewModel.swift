//
//  ViewModel.swift
//  ManageDay
//
//  Created by Piotr Woźniak on 13/11/2022.
//

import Foundation
import CoreData
import UserNotifications

class ViewModel: ObservableObject {
    @Published var addNewHabit = false
    @Published var title: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    @Published var notificationAccess = false
    
    init() {
        requestNotificationStatus()
    }
    func requestNotificationStatus() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
}
