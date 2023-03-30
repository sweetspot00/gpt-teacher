//
//  ChooseLanguageView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/29.
//

import SwiftUI

struct ChooseLanguageView: View {
    let languages = ["English", "Spanish", "French", "German", "Chinese"]
    @State private var selectedLanguage: String?
    @State private var isNextViewActive = false
    
    var body: some View {
        VStack {
            Text("Choose your native language")
                .font(.headline)
                .padding()
            
            List(languages, id: \.self) { language in
                Button(action: {
                    userMotherLanguage = language
                    selectedLanguage = language
                    isNextViewActive = true
                }) {
                    Text(language)
                }
            }
        }
        .padding()
        .sheet(isPresented: $isNextViewActive, content: {
            TeacherListView()
        })
    }
}

struct ChooseLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLanguageView()
    }
}
