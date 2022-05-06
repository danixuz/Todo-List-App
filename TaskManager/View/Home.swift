//
//  Home.swift
//  TaskManager
//
//  Created by Daniel Spalek on 04/05/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var taskModel: TaskViewModel = .init()
    // MARK: Matched Geometry Namespace
    @Namespace var animation
    
    // MARK: Fetching task
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    // MARK: Environment Values
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack{
                VStack(alignment: .leading, spacing: 8){
                    Text("Welcome Back")
                        .font(.callout)
                    Text("Here are today's updates")
                        .font(.title2.bold())
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                CustomSegmentedBar()
                    .padding(.top, 5)
                
                // MARK: Task View
                TaskView()
                
                Text("Version 1.0 - Created by Daniel Spalek")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.vertical)
            }
            .padding()
        }
        .overlay(alignment: .bottom){
            // MARK: Add button
            Button {
                taskModel.openEditTask.toggle()
            } label: {
                Label {
                    Text("Add Task")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())

            }
            
            //MARK: Linear Gradient Background
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [
                    Color(.systemBackground).opacity(0.05),
                    Color(.systemBackground).opacity(0.4),
                    Color(.systemBackground).opacity(0.7),
                    Color(.systemBackground)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }

        }
        .fullScreenCover(isPresented: $taskModel.openEditTask) {
            //onDismiss
            taskModel.resetTaskData()
        } content: {
            AddNewTask()
                .environmentObject(taskModel)
        }

    }
    // MARK: Task View
    @ViewBuilder
    func TaskView() -> some View{
        LazyVStack(spacing: 20){
            // MARK: Custom filtered request view
            ForEach(tasks){ task in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: Task row view
    @ViewBuilder
    func TaskRowView(task: Task) -> some View{
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.gray.opacity(0.3))
                    }
                
                Spacer()
                
                // MARK: edit button only for non-completed tasks
                if !task.isCompleted{
                    Button {
                        taskModel.editTask = task
                        taskModel.openEditTask = true
                        taskModel.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }

                }
            }
            
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0){
                VStack(alignment: .leading, spacing: 10){
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                    

                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                if !task.isCompleted{
                    Button {
                        // MARK: Updating core data
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                            .foregroundColor(.black)
                    }

                }
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Yellow"))
        }
    }
    
    
    // MARK: Custom Segmented Bar
    @ViewBuilder
    func CustomSegmentedBar() -> some View{
        let tabs = ["Today", "Upcoming", "Task Done"]
        HStack(spacing: 10){
            ForEach(tabs, id: \.self){ tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskModel.currentTab == tab ? .blue : .gray)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskModel.currentTab == tab{
                            Capsule()
                                .fill(Color(.systemGray5))
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation{taskModel.currentTab = tab}
                    }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
        
    }
}
