//
//  BotResponse.swift
//  ChatTest
//
//  Created by Federico on 20/11/2021.
//

import Foundation
import OpenAISwift
import Async

public func getGPTResponse(client: OpenAISwift, input: String, completion: @escaping (String) -> Void) {
    client.sendCompletion(with: input, completionHandler: { result in
        switch result {
        case .success(let model):
            let output = model.choices.first?.text ?? ""
            completion(output)
        case .failure(_):
            completion("error")
//            completion(.failure(error))
        }
    })
}
