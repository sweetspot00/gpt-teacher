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
    @State var openTranslation = false
    
    var body: some View {
        
        VStack {
            
            Text("Use the following phrases to complete✅. You will get a report after full chat.")
                .multilineTextAlignment(.center)
                .font(.headline)
//                .lineLimit(1)
                .frame(width: 300)
                .padding(.top, 20)

            VStack() {
                ScrollView {
                   VStack(spacing: 20) {
                       ForEach(tasks.indices, id: \.self) { index in
                           let taskText = tasks[index] + (isTaskCompleted[index] ? " ✅" : "")
                           Text("\(index + 1)" + ". " + "\(taskText)")
                               .font(.subheadline)
                               .foregroundColor(isTaskCompleted[index] ? .gray : .black)
        //                       .strikethrough(completedTasks.contains(index))
                               .frame(maxWidth: .infinity, alignment: .leading)
                       }
                   }.padding()
                    
               }
                
                // translate
                Button(action: {
                    openTranslation = true
                }) {
                    Text("Translate")
                        .font(.subheadline)
                }.sheet(isPresented: $openTranslation, onDismiss: {
                    // 页面关闭后执行的代码
                    print("页面已关闭")
                }) {
                    let toTranslate = convertToStringWithNumbers(strings: tasks)
                    TranslationView(originalText: toTranslate)
                }
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
    
    func convertToStringWithNumbers(strings: [String]) -> String {
        var result = ""
        for (index, string) in strings.enumerated() {
            let numberedString = "\(index + 1). \(string)\n"
            result += numberedString
        }
        return result
    }

}

//struct TaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskView()
//    }
//}
