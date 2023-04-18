//
//  BotResponse.swift
//  ChatTest
//
//  Created by Federico on 20/11/2021.
//

import Foundation
import OpenAISwift

public func getGPTChatResponse(client: OpenAISwift, input: [ChatMessage], completion: @escaping(String) -> Void) {
    client.sendChat(with: input, model: .chat(.chatgpt)) { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.message.content ?? ""
//                print("ChatGPT: \(output)")
                completion(output)
            case .failure(let error):
                let output = error.localizedDescription
                completion(output)
            }
    }
    
}

