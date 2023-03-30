//
//  TranslationView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//
import SwiftUI

struct TranslationView: View {
    var originalText: String = ""
    @State private var translatedText: String = ""
    
    var body: some View {
        VStack {
            
            Text(originalText)
                .frame(maxHeight: .infinity)
            Divider()
            HStack(spacing: 10) {
                
                Text("Translate to")
                    .foregroundColor(Color("ailinPink"))
                    .font(.title)
                    .bold()
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("ailinPink"), lineWidth: 1)
                    .frame(width: 90, height: 40)
                    .overlay(
                        Text("\(userMotherLanguage)")
                        .foregroundColor(Color("ailinPink"))
                        .font(.headline)
                    )
                Spacer()
            }.padding(.horizontal, 10)
            
            TextEditor(text: $translatedText)
                .frame(maxHeight: .infinity)
            
        }.padding(.all, 15)
        .onAppear {
            // TODO: API call to translate
            
        }
    }
}

struct TranslationView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView()
    }
}

