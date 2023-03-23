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
import MicrosoftCognitiveServicesSpeech
import AVFoundation

class AzureService {
    
    var inputText = ""
    
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
        
        // MARK: Azure synthesizer config
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: AZURE_KEY, region: AZURE_REGION)
        } catch {
            print("error \(error) happened")
            speechConfig = nil
        }
        
        speechConfig?.speechSynthesisVoiceName = speakerName;
        synthesizer = try! SPXSpeechSynthesizer(speechConfig!)

//        synthesizer = try!
        
        if inputText.isEmpty {
            return
        }
        
        
        let result = try! synthesizer.speakText(inputText)
    
//        let ssmlInput = "<speak version='1.0' xmlns='http://www.w3.org/2001/10/synthesis' xml:lang='en-US'><voice name='en-US-AriaNeural'>Hello, world!</voice></speak>"

        // Synthesize speech from the SSML input
//        let result = try! synthesizer.speakSsml(ssmlInput)
        if result.reason == SPXResultReason.canceled
        {
            let cancellationDetails = try! SPXSpeechSynthesisCancellationDetails(fromCanceledSynthesisResult: result)
            print("cancelled, detail: \(cancellationDetails.errorDetails!) ")
//            try! audioSession.setActive(false)
        }
        // stop audioSession
       
    }
    
    
}
