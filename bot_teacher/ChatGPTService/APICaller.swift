//
//  APICaller.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import Foundation
import OpenAISwift
import Async

final class APICaller {
    
    static let shared = APICaller()
    
    @frozen enum Constants {
        static let key = "somekey"
    }
    
    public var client: OpenAISwift?
    
    init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
    }
    
    public func getClient() -> OpenAISwift {
        return client!
    }
    
    public func getGPTResponse(client: OpenAISwift, input: String, completion: @escaping (Result<String, Error>) -> Void) {
        client.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
   
}
