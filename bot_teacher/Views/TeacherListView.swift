//
//  TeacherListView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/15.
//

import SwiftUI
import OpenAISwift
import Speech


struct TeacherListView: View {

    @State private var selectedButtonIndex = 1
    @State var selectedChatTeacher: String = ""
    var userName = "MOMO"
    @State var isSelected = false
    @State var language = ""
    
    
    var body: some View {
        VStack {
            // user info
            HStack {
                Image("portriat")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                HStack {
                    VStack(alignment: .leading) {
                        Text(userName)
                            .font(.headline)
                        Text("How are you")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
            }
            .padding(.all, 15)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Voice chat with")
                        .font(.headline)
                        .frame(alignment: .leading).padding([.leading], 15)
                    Spacer()
                }

            }
            
            // language buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20){
                    ForEach(ltmodels.indices) { index in
                        Button(action: {
                                selectedButtonIndex = index // Set the selected button index
                                language = ltmodels[index].language
                            }) {
                                Text(ltmodels[index].language)
                                    .padding([.all], 10)
                                    .background(selectedButtonIndex == index ? Color("ailinPink") : Color.gray.opacity(0.3)) // Change the color based on the selection state
                                    .foregroundColor(selectedButtonIndex == index ? Color.white : Color.black)
                                    .cornerRadius(10)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .lineLimit(1)
                            }

                    }
                }.padding(.horizontal, 15)
            }
            
            // character list
            VStack {
                HStack {
                    Text("List of AI characters")
                        .font(.headline)
                        .frame(alignment: .leading)
                    Spacer()
                }
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150)), GridItem(.adaptive(minimum: 150))], spacing: 10) {
                        ForEach(ltmodels[selectedButtonIndex].peoples,id: \.self) { people in
                                VStack {
                                    Button {

                                            // open ChatView
                                        selectedChatTeacher = people.name
                                        isSelected.toggle()
                                        print("select")

                                        
                                    } label: {
                                        Image(people.image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 150)
                                            .clipped()
                                            .cornerRadius(CGFloat(10))
                                    }
                                    Text(people.name)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                }
                                .onChange(of:selectedChatTeacher){_ in }
                            
//                            print(selectedChatTeacher)zh

                        }
                    }
                }
                .fullScreenCover(isPresented: $isSelected) {
                    ChatView(chatTeacherName: selectedChatTeacher, userName: userName, client: APICaller().getClient()) {
                        self.isSelected.toggle()
                    }

                }
                
                .padding(.horizontal, 15)
            }.padding(.horizontal, 15)

        }

    }
    

}




struct TeacherListView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherListView()
    }
}
