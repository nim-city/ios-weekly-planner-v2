//
//  Persistence.swift
//  WeeklyPlannerV2
//
//  Created by Nimish Narang on 2025-09-06.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()
    
    @MainActor
    static let preview: PersistenceController = {
        
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create mock weekly schedule
        let _ = createMockWeeklySchedule(moc: viewContext)
        
        return controller
    }()
    
    @MainActor
    static func createMockWeeklySchedule(moc: NSManagedObjectContext? = nil) -> WeeklySchedule {
        
        let viewContext = moc ?? {
            let result = PersistenceController(inMemory: true)
            return result.container.viewContext
        }()

        // Add a weekly schedule
        let weeklySchedule = WeeklySchedule(context: viewContext)
        weeklySchedule.id = UUID()
        weeklySchedule.name = "Weekly schedule"
        weeklySchedule.categoryName = WeeklyScheduleCategory.work.rawValue
        
        // Add Goals
        weeklySchedule.goals = .init([
            
            // Daily
            Goal.createMockGoal(name: "Read for 15 minutes", category: .daily, completed: false, createdAt: Date(), notes: "", moc: viewContext),
            Goal.createMockGoal(name: "Stretch", category: .daily, completed: false, createdAt: Date(), notes: "For 15 minutes", moc: viewContext),
            
            // Weekly
            
            // Long term
            Goal.createMockGoal(name: "Climb Mount Everest", category: .longTerm, moc: viewContext),
            Goal.createMockGoal(name: "Buy a house", category: .longTerm, notes: "Or apartment", moc: viewContext)
        ])
        
        // Add daily schedules
        let dailySchedules = Weekday.allCases.map { weekday in
            let newDailySchedule = DailySchedule(context: viewContext)
            newDailySchedule.weekdayIndex = Int16(weekday.rawValue)
            newDailySchedule.taskBlocks = .init()
            return newDailySchedule
        }
        weeklySchedule.dailySchedules = NSOrderedSet(array: dailySchedules)
        
        // Add task item blocks
        // Meals
        let mealsTaskBlock = TaskBlock.createMockTaskBlock(name: "Meals", category: .food, startHour: 0, endHour: 1, moc: viewContext)
        dailySchedules.first?.addTaskBlock(mealsTaskBlock)
        
        // To buy items
        let toBuyItemsTaskBlock = TaskBlock.createMockTaskBlock(name: "Purchases", category: .shopping, startHour: 1, endHour: 2, moc: viewContext)
        dailySchedules.first?.addTaskBlock(toBuyItemsTaskBlock)
        
        // To do items
        let toDoItemsTaskBlock = TaskBlock.createMockTaskBlock(name: "Leisure activities", category: .leisure, startHour: 2, endHour: 3, moc: viewContext)
        dailySchedules.first?.addTaskBlock(toDoItemsTaskBlock)
        
        // Workouts
        let workoutsTaskBlock = TaskBlock.createMockTaskBlock(name: "Gym", category: .exercise, startHour: 4, endHour: 8, moc: viewContext)
        dailySchedules.first?.addTaskBlock(workoutsTaskBlock)
        
        // Add meals
        mealsTaskBlock.addToTaskItems(Meal.createMockMeal(name: "Breakfast", category: .breakfast, moc: viewContext))
        mealsTaskBlock.addToTaskItems(Meal.createMockMeal(name: "Bacon and eggs", category: .breakfast, moc: viewContext))
        mealsTaskBlock.addToTaskItems(Meal.createMockMeal(name: "Lunch", category: .lunch, moc: viewContext))
        mealsTaskBlock.addToTaskItems(Meal.createMockMeal(name: "Dinner", category: .dinner, moc: viewContext))
        mealsTaskBlock.addToTaskItems(Meal.createMockMeal(name: "Snack", category: .snack, moc: viewContext))
        
        // Add to buy items
        toBuyItemsTaskBlock.addToTaskItems(ToBuyItem.createMockToBuyItem(name: "Milk", priority: .high, moc: viewContext))
        toBuyItemsTaskBlock.addToTaskItems(ToBuyItem.createMockToBuyItem(name: "Butter", priority: .high, moc: viewContext))
        toBuyItemsTaskBlock.addToTaskItems(ToBuyItem.createMockToBuyItem(name: "Eggs", priority: .high, moc: viewContext))
        toBuyItemsTaskBlock.addToTaskItems(ToBuyItem.createMockToBuyItem(name: "Couch cushions", priority: .moderate, moc: viewContext))
        toBuyItemsTaskBlock.addToTaskItems(ToBuyItem.createMockToBuyItem(name: "Apartment", priority: .low, moc: viewContext))
        
        // Add to do items
        toDoItemsTaskBlock.addToTaskItems(ToDoItem.createMockToDoItem(name: "Read", category: .leisure, priority: .low, recurring: true, moc: viewContext))
        toDoItemsTaskBlock.addToTaskItems(ToDoItem.createMockToDoItem(name: "Clean kitchen", category: .chore, priority: .low, recurring: false, moc: viewContext))
        toDoItemsTaskBlock.addToTaskItems(ToDoItem.createMockToDoItem(name: "Shower", category: .routine, priority: .high, recurring: true, moc: viewContext))
        toDoItemsTaskBlock.addToTaskItems(ToDoItem.createMockToDoItem(name: "Study for interview", category: .study, priority: .moderate, recurring: true, moc: viewContext))
        toDoItemsTaskBlock.addToTaskItems(ToDoItem.createMockToDoItem(name: "Review PRs", category: .work, priority: .high, recurring: false, moc: viewContext))
        
        // Add workouts
        workoutsTaskBlock.addToTaskItems(Workout.createMockWorkout(name: "Chest day", exercises: ["Bench", "Cable flyes", "Incline press"], moc: viewContext))
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return weeklySchedule
    }
    
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WeeklyPlannerV2")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
