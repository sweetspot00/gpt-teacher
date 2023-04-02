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
            let input = ChatMessage(role: .system, content: "tranlate to \(userMotherLanguage): \n" + originalText)
            // TODO: API call to translate
            getGPTChatResponse(client: APICaller().getClient(), input: [input]) { response in
                translatedText = response
            }
            
        }
        
    }
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

