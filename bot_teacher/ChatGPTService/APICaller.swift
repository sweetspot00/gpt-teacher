//
//  APICaller.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import Foundation
import OpenAISwift
import Async
import OpenAIKit

final class APICaller: ObservableObject {
    
    static let shared = APICaller()
    
    @frozen enum Constants {
        static let key = "some key"
    }
    
    public var client: OpenAISwift?
    public var openAIObject: OpenAIKit.OpenAI?
    
    init() {}
    
    public func setup() {
        self.client = OpenAISwift(authToken: Constants.key)
        let config = Configuration(organizationId: "nil", apiKey: Constants.key)
        openAIObject = OpenAI(config)
    }
    
    public func getClient() -> OpenAISwift {
        return client!
    }
    
    public func getOpenAIObject() -> OpenAIKit.OpenAI {
        return openAIObject!
    }
    
    public func getGPTResponse(client: OpenAISwift, input: String,completion: @escaping (Result<String, Error>) -> Void) {
        client.sendCompletion(with: input, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let success):
                let output = success.choices.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
//    public func getGPT3Response(input: String, client: OpenAIKit.OpenAI, completion: @escaping (Result<String, Error>) -> Void) {
//        let completionParameter = CompletionParameters(
//              model: "text-davinci-001",
//              prompt: ["Say this is a test ->"],
//              maxTokens: 4,
//              temperature: 0.98
//            )
//
//        client.generateCompletion(parameters: completionParameter)
//    }
//
   
}
