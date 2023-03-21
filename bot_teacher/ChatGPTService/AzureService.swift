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
import AVFoundation

class AzureService {
    
    var inputText = ""
    
    var speakerName: String = ""
    var rate: Float?
    var pitch: Float?

    func config(with name: String, rate: Float? = nil, pitch: Float? = nil) {
        self.speakerName = name
        self.rate = rate
        self.pitch = pitch
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

        
        if inputText.isEmpty {
            return
        }
        
        
        let result = try! synthesizer.speakText(inputText)
        
        
        if result.reason == SPXResultReason.canceled
        {
            let cancellationDetails = try! SPXSpeechSynthesisCancellationDetails(fromCanceledSynthesisResult: result)
            print("cancelled, detail: \(cancellationDetails.errorDetails!) ")
//            try! audioSession.setActive(false)
        }
        do {
            try audioEngine.start()
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
        playerNode.play()
    }
}