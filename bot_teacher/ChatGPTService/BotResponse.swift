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
                let output = model.choices.first?.message.content ?? ""
                print("ChatGPT: \(output)")
                completion(output)
            case .failure(let error):
                let output = error.localizedDescription
                completion(output)
            }
    }
    
}

func getGPTChatResponseAddTimeout(client: OpenAISwift, input: [ChatMessage], timeout: TimeInterval, completion: @escaping (String) -> Void) {
    let semaphore = DispatchSemaphore(value: 0)

    // Execute the asynchronous task
    // Replace the following line with your actual asynchronous task
    DispatchQueue.global().async {
        // ... your asynchronous task
        client.sendChat(with: input, model: .chat(.chatgpt)) { result in
                switch result {
                case .success(let model):
                    let output = model.choices.first?.message.content ?? ""
                    print("ChatGPT: \(output)")
                    completion(output)
                case .failure(let error):
                    let output = error.localizedDescription
                    completion(output)
                }
        }
//        completion("Result from your async task")
        semaphore.signal()
    }

    // Wait for the result with a timeout
    let timeoutResult = semaphore.wait(timeout: .now() + timeout)

    if timeoutResult == .timedOut {
        print("Timeout occurred")
        // Handle the timeout, e.g., by stopping the task or setting a default result
        completion("OpenAI Request Timeout")
    }
}

