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

class AzureSerivce {
    
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
        
        let audioSession = AVAudioSession.sharedInstance()

        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
            try audioSession.setActive(true)
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }
        let audioEngine = AVAudioEngine()
        let playerNode = AVAudioPlayerNode()

        audioEngine.attach(playerNode)
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000, channels: 1, interleaved: false)

        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)

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
            try! audioSession.setActive(false)
        }
        // stop audioSession
       
    }
    
    
}
