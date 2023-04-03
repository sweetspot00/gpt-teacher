//
//  TranslationView.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/28.
//
import SwiftUI
import Foundation
import Alamofire
import OpenAISwift


struct TranslationView: View {
    var originalText: String = ""
    @State private var translatedText: String = ""
    @State private var selectedLanguage = userMotherLanguage
    let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Korean", "Russian", "Italian", "Portuguese"]
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Text(originalText)
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(6)
                            .frame(maxHeight: .infinity)
                        Spacer()
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.bottom)
            Spacer()
            Divider()
            HStack(spacing: 10) {
                
                Text("Translate to")
                    .foregroundColor(Color("ailinPink"))
                    .font(.title)
                    .bold()
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("ailinPink"), lineWidth: 1)
                    .frame(width: 120, height: 40)
                    .overlay(
                        Picker(selection: $selectedLanguage, label: EmptyView()) {
                            ForEach(languages, id: \.self) { language in
                                Text(language)
                                    .foregroundColor(Color("ailinPink"))
                                    .tag(language)
                            }
                        }
                        .onChange(of: selectedLanguage) { _ in
                            translateAgain()
                        }
                        .foregroundColor(Color("ailinPink"))
                        .font(.headline)
                        .clipped()
                    )
                Spacer()
            }.padding(.horizontal, 10)
            
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        Text(translatedText)
                            .font(.system(size: 18))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(6)
                            .frame(maxHeight: .infinity)
                        Spacer()
                    }
                }
                .padding()
            }
            .edgesIgnoringSafeArea(.bottom)
            
        }.padding(.all, 15)
        .onAppear {
            let input = ChatMessage(role: .system, content: "tranlate to \(userMotherLanguage): \n" + originalText)
            // TODO: API call to translate
            getGPTChatResponse(client: APICaller().getClient(), input: [input]) { response in
                translatedText = response
            }
            
        }
        
    }
    
    func translateAgain() {
        let input = ChatMessage(role: .system, content: "tranlate to \(selectedLanguage): \n" + originalText)
        // TODO: API call to translate
        getGPTChatResponse(client: APICaller().getClient(), input: [input]) { response in
            translatedText = response
        }
    }
    
    /// azure
    func translateText(text: String,toLanguage: String, completionHandler: @escaping (String?) -> Void) {

        let urlString = "https://api.cognitive.microsofttranslator.com/translator/text/v3.0/translate?to=\(toLanguage)"
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": AZURE_TRANSLATION_KEY,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "Text": text
        ]

        AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseString { response in
            switch response.result {
            case .success(let value):
                print("Response: \(value)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}




struct TranslationView_Previews: PreviewProvider {
    static var previews: some View {
        TranslationView()
    }
}

