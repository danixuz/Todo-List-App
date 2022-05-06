//
//  AddNewTask.swift
//  TaskManager
//
//  Created by Daniel Spalek on 04/05/2022.
//

import SwiftUI

struct AddNewTask: View {
    @EnvironmentObject var taskModel: TaskViewModel
    // MARK: All Environment values in one variable:
    @Environment(\.self) var env
    @Namespace var animation
    var body: some View {
        VStack(spacing: 12){
            Text("Edit Task")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading){
                    Button {
                        env.dismiss()
//                        taskModel.openEditTask.toggle()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title3)
                    }

                }
            
            // MARK: Color selection section
            VStack(alignment: .leading, spacing: 12){
                Text("Task Color")
                    .font(.caption)
                    .foregroundColor(.gray)
                // MARK: Sample card colors
                let colors: [String] = ["Yellow", "Green", "Blue", "Purple", "Red", "Orange"]
                HStack(spacing: 15){
                    ForEach(colors, id: \.self){ color in
                        Circle()
                            .fill(Color(color))
                            .frame(width: 25, height: 25)
                            .background{
                                if taskModel.taskColor == color{
                                    Circle()
                                        .strokeBorder(.blue, lineWidth: 1.5)
                                        .padding(-3)
                                }
                            }
                            .contentShape(Circle())
                            .onTapGesture {
                                taskModel.taskColor = color
                            }
                    }
                }
                .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            
            Divider()
                .padding(.vertical, 10)
            
            // MARK: Task Deadline
            VStack(alignment: .leading, spacing: 12){
                Text("Task Deadline")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(taskModel.taskDeadLine.formatted(date: .abbreviated, time: .omitted) + ", " + taskModel.taskDeadLine.formatted(date: .omitted, time: .shortened))
                    .font(.callout)
                    .fontWeight(.semibold)
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .bottomTrailing){
                Button {
                    taskModel.showDatePicker.toggle()
                } label: {
                    Image(systemName: "calendar")
                }

            }
            Divider()
                .padding(.vertical, 10)
            
            // MARK: Task Title
            VStack(alignment: .leading, spacing: 12){
                Text("Task Title")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                TextField("", text: $taskModel.taskTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
            
            Divider()
                .padding(.vertical, 10)
            
            // MARK: Task Type
            let taskTypes: [String] = ["Basic", "Urgent", "Important"]
            VStack(alignment: .leading, spacing: 12){
                Text("Task Type")
                    .font(.caption)
                    .foregroundColor(.gray)
                HStack(spacing: 12){
                    ForEach(taskTypes, id: \.self){ type in
                        Text(type)
                            .font(.callout)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background {
                                if taskModel.taskType == type{
                                    Capsule()
                                        .fill(Color(.systemGray5))
                                        .matchedGeometryEffect(id: "TYPE", in: animation)
                                }else{
                                    Capsule()
                                        .strokeBorder(.gray)
                                }
                            }
                            .contentShape(Capsule())
                            .onTapGesture {
                                withAnimation {
                                    taskModel.taskType = type
                                }
                            }
                    }
                }
                .padding(.top, 8)
                
            }
            .padding(.vertical, 10)
            
            Divider()
            
            // MARK: Save Button
            
            Button {
                // MARK: If success closing view.
                if taskModel.addTask(context: env.managedObjectContext){
                    env.dismiss()
                }
            } label: {
                Text("Save Task")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .foregroundColor(.white)
                    .background{
                        Capsule()
                            .fill(.blue)
                    }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 10)
            .disabled(taskModel.taskTitle == "") //do not save if name is empty
            .opacity(taskModel.taskTitle == "" ? 0.6 : 1)

        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        .overlay {
            ZStack{
                if taskModel.showDatePicker{
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                        .onTapGesture {
                            taskModel.showDatePicker = false
                        }
                    // MARK: Pick date between now and the future
                    DatePicker.init("", selection: $taskModel.taskDeadLine, in: Date.now...Date.distantFuture)
                        .labelsHidden()
                        .datePickerStyle(.graphical)
                        .padding()
                        .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .padding()
                }
            }
            .animation(.easeInOut, value: taskModel.showDatePicker)
        }
    }
}

struct AddNewTask_Previews: PreviewProvider {
    static var previews: some View {
        AddNewTask().environmentObject(TaskViewModel())
    }
}
