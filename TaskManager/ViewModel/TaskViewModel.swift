//
//  TaskViewModel.swift
//  TaskManager
//
//  Created by Daniel Spalek on 04/05/2022.
//

import SwiftUI
import CoreData

class TaskViewModel: ObservableObject {
    @Published var currentTab: String = "Today"
    
    // MARK: Default properties for new task
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Yellow"
    @Published var taskDeadLine: Date = Date()
    @Published var taskType: String = "Basic"
    @Published var showDatePicker: Bool = false
    
    // MARK: Editing an existing task's data
    @Published var editTask: Task?
    
    // MARK: Adding task to Core Data
    func addTask(context: NSManagedObjectContext) -> Bool {
        // MARK: Updating existing data in core data
        var task: Task!
        if let editTask = editTask {
            task = editTask
        }else{
            task = Task(context: context)
        }
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadLine
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save(){
            return true
        }
        return false
    }
    
    // MARK: Resetting data
    func resetTaskData(){
        taskType = "Basic"
        taskColor = "Yellow"
        taskTitle = ""
        taskDeadLine = Date()
    }
    
    // MARK: If task editing is active then setting existing data...
    func setupTask(){
        if let editTask = editTask{
            taskType = editTask.type ?? ""
            taskColor = editTask.color ?? "Yellow"
            taskTitle = editTask.title ?? ""
            taskDeadLine = editTask.deadline ?? Date()
        }
    }
}
