//
//  APICaller.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import Foundation
import OpenAISwift
import OpenAIKit

final class APICaller: ObservableObject {
    
    static let shared = APICaller()
    
//    @frozen enum Constants {
//        static let key = "some key"
//    }
    var key = ""
    
    public var client: OpenAISwift?
    public var openAIObject: OpenAIKit.OpenAI?
    
    init() {}

    
    public func setup(with openAIKey: String) {
        self.key = openAIKey
        self.client = OpenAISwift(authToken: openAIKey)
    }
    
    public func getClient() -> OpenAISwift {
        return client!
    }
    
    public func getOpenAIObject() -> OpenAIKit.OpenAI {
        return openAIObject!
    }
    
    public func getGPTResponse(client: OpenAISwift, input: String,completion: @escaping (Result<String, Error>) -> Void) {
        client.sendCompletion(with: input,model:.chat(.chatgpt0301), maxTokens: 500, completionHandler: { result in
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
