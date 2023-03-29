//
//  TranslationView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//
import SwiftUI

struct TranslationView: View {
    @State private var originalText: String = ""
    @State private var translatedText: String = ""
    
    var body: some View {
        VStack {
            TextEditor(text: $originalText)
                .frame(maxHeight: .infinity)
            Divider()
            TextEditor(text: $translatedText)
                .frame(maxHeight: .infinity)
        }
        .padding()
    }
}

