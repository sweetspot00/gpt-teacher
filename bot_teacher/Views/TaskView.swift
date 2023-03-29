//
//  TaskView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//

import SwiftUI

struct TaskView: View {
    
    @Binding var isTaskCompleted: [Bool]
    var teacherName: String = ""
    @State var tasks: [String]
    
    var body: some View {
        
        VStack {
            
            Text("Task about \(teacherName)")
                .font(.headline)
                .lineLimit(1)
                .frame(width: 300)
                .padding(.top, 20)

            
            ScrollView {
               VStack(spacing: 20) {
                   ForEach(tasks.indices, id: \.self) { index in
                       let taskText = tasks[index] + (isTaskCompleted[index] ? " ✅" : "")
                       Text(taskText)
                           .font(.headline)
                           .foregroundColor(isTaskCompleted[index] ? .gray : .black)
    //                       .strikethrough(completedTasks.contains(index))
                   }
               }.padding()
                
           }
        }.rotation3DEffect(
            .degrees(180),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .frame(width: 300, height: 300)
        
    }
    
    private func toggleTask(_ index: Int) {
        isTaskCompleted[index].toggle()
    }
}

//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView()
//    }
//}
