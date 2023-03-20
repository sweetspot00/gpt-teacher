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
    
    var speakerName: String
    var rate: Float?
    var pitch: Float?

    func config(with name: String, rate: Float? = nil, pitch: Float? = nil) {
        self.speakerName = name
        self.rate = rate
        self.pitch = pitch
    }
    
    func changeInputTextAndPlay(with input: String) {
        inputText = input
        self.synthesize()
    }
    func sendRequest() {
    let url = URL(string: "https://speech-functions-cfgfd3fyb8gmhwbj.z01.azurefd.net/api/synthesize")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let parameters: [String: Any] = ["text": inputText, "voice": speakerName]
    if rate != nil {
        parameters["rate"] = rate
    }
    if pitch != nil {
        parameters["pitch"] = pitch
    }
    let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
    request.httpBody = jsonData
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print(error?.localizedDescription ?? "No data")
            return
        }
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            if let file = responseJSON["file"] as? String {
                        DispatchQueue.main.async {
                            self.playSound(file: file)
                        }
            }
        }
    }
    task.resume()
    }

    func playSound(file: String) {
        let dataDecoded : Data = Data(base64Encoded: file, options: .ignoreUnknownCharacters)!
        let decodedString = String(data: dataDecoded, encoding: .utf8)!
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
        playerNode.scheduleBuffer(dataDecoded, at: nil, options: .loops, completionHandler: nil)
        do {
            try audioEngine.start()
        }
         catch {
            print("Error starting audio engine: \(error.localizedDescription)")
        }
        playerNode.play()
    }
}