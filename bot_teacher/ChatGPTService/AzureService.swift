//
//  AzureService.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/12.
//
// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.md file in the project root for full license information.
//

// <code>
import UIKit
import MicrosoftCognitiveServicesSpeech

class AzureSerivce {
    
    var inputText = ""
    
    let sub = "e7752c67ecf8482894bd9f4314b38fba"
    let region = "southeastasia"
    var speakerName: String!
    var synthesizer = SPXSpeechSynthesizer()
    
    func config(with name: String) {
        self.speakerName = name
    }
    
    func changeInputTextAndPlay(with input: String) {
        inputText = input
        self.synthesisToSpeaker()
    }
    

    func synthesisToSpeaker() {
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: sub, region: region)
        } catch {
            print("error \(error) happened")
            speechConfig = nil
        }
        
        speechConfig?.speechSynthesisVoiceName = speakerName;
        synthesizer = try! SPXSpeechSynthesizer(speechConfig!)
        
        if inputText.isEmpty {
            return
        }
        let result = try! synthesizer.speakText(inputText)
        if result.reason == SPXResultReason.canceled
        {
            let cancellationDetails = try! SPXSpeechSynthesisCancellationDetails(fromCanceledSynthesisResult: result)
            print("cancelled, detail: \(cancellationDetails.errorDetails!) ")
        }

    }
    
    
}
// </code>
