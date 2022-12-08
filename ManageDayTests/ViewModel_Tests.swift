//
//  ManageDayTests.swift
//  ManageDayTests
//
//  Created by Piotr Woźniak on 28/11/2022.
//

import XCTest
import CoreData
@testable import ManageDay

final class ViewModel_Tests: XCTestCase {
    var controller: PersistenceController!
    var context: NSManagedObjectContext {
        controller.container.viewContext
    }
    var sut: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        controller = PersistenceController.empty
        sut = HomeViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        controller = nil
        sut = nil
    }

    func test_HomeViewModel_addHabit_shouldReturnTrue_isRemainderOnFalse_editHabitNil() async {
        guard sut.habitColor == "Card-1", sut.isRemainderOn == false else {
            return XCTFail()
        }
        
        let number2 = "Card-2"
        
        sut.habitColor = number2
        XCTAssertTrue(sut.habitColor == number2)
        
        let habit = Habit(context: context)
        habit.color = sut.habitColor
        try? context.save()
        
        XCTAssertEqual(habit.color, number2)
        XCTAssertEqual(sut.habitColor, habit.color)

        let boolValue = await sut.addHabit(context: context)
        
        XCTAssertTrue(boolValue)
    }
    
    func test_HomeViewModel_addHabit_shouldReturnTrue_isRemainderOnFalse_editHabitNotNil() async {
        guard sut.habitColor == "Card-1", sut.isRemainderOn == false else {
            return XCTFail()
        }
        
        let number2 = "Card-2"
        let number3 = "Card-3"
        
        sut.habitColor = number2
        XCTAssertTrue(sut.habitColor == number2)
        
        let habit = Habit(context: context)
        habit.color = sut.habitColor
        try? context.save()
        
        XCTAssertEqual(habit.color, number2) //from color number2 (notNil)
        XCTAssertEqual(sut.habitColor, habit.color)
        
        sut.editHabit = habit
        XCTAssertEqual(sut.editHabit, habit)
        
        sut.habitColor = number3
        XCTAssertTrue(sut.habitColor == number3)

        let boolValue = await sut.addHabit(context: context)
        
        XCTAssertEqual(habit.color, number3) // to color number3 (notNil)
        XCTAssertTrue(boolValue)
    }
    
    func test_HomeViewModel_scheduleNotification_shouldReturnArrayOfStrings() async {
        guard sut.weekDays.isEmpty else {
            return XCTFail()
        }
        
        let weekDaysList = Calendar.current.weekdaySymbols
        
        for item in 0..<weekDaysList.count {
            var itemsArray = [String]()
            
            for number in 0..<item {
                let filteredItem = weekDaysList.filter { $0 == weekDaysList[number] }
                itemsArray.append(contentsOf: filteredItem)
            }
            
            sut.weekDays = itemsArray
            XCTAssertEqual(sut.weekDays.count, itemsArray.count)
            
            do {
                let returnedArray = try await sut.scheduleNotification()
                XCTAssertEqual(sut.weekDays.count, returnedArray.count)
                XCTAssertEqual(itemsArray.count, returnedArray.count)
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_HomeViewModel_deleteHabit_shouldReturnTrue() {
        guard sut.editHabit == nil else {
            return XCTFail()
        }
        // number of habits: 0
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        let numberOfHabits1 = try? context.count(for: fetchRequest1)
        XCTAssertTrue(numberOfHabits1 == 0)
        
        let habit = Habit(context: context)
        try? context.save()
        
        sut.editHabit = habit
        XCTAssertTrue(sut.editHabit != nil)
        XCTAssertEqual(sut.editHabit, habit)
        
        // number of habits: 1
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        let numberOfHabits2 = try? context.count(for: fetchRequest2)
        XCTAssertTrue(numberOfHabits2 == 1)
        
        // delete habit
        let boolResult = sut.deleteHabit(context: context)
        XCTAssertTrue(boolResult)
        
        // number of habits: 0
        let fetchRequest3 = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        let numberOfHabits3 = try? context.count(for: fetchRequest3)
        XCTAssertTrue(numberOfHabits3 == 0)
        
        XCTAssertNotEqual(numberOfHabits2, numberOfHabits1)
        XCTAssertEqual(numberOfHabits1, numberOfHabits3)
    }
    
    func test_HomeViewModel_deleteHabit_shouldReturnFalse() {
        guard sut.editHabit == nil else {
            return XCTFail()
        }
        
        // number of habits: 0
        let fetchRequest1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        let numberOfHabits1 = try? context.count(for: fetchRequest1)
        XCTAssertTrue(numberOfHabits1 == 0)

        // delete habit
        let boolResult = sut.deleteHabit(context: context)
        XCTAssertFalse(boolResult)
        
        // number of habits: 0
        let fetchRequest2 = NSFetchRequest<NSFetchRequestResult>(entityName: "Habit")
        let numberOfHabits2 = try? context.count(for: fetchRequest2)
        XCTAssertTrue(numberOfHabits2 == 0)
        
        XCTAssertEqual(numberOfHabits1, numberOfHabits2)
    }
}
