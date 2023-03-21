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

class AzureServicePostRequest {
    
    var inputText = ""
    
    var speakerName: String = "en-US-CoraNeural"
    var rate: String = "20%"
    var pitch: String = "30%"

    func config(with name: String) {
        self.speakerName = name
//        self.rate = rate ??
//        self.pitch = pitch
    }
    
    func changeInputTextAndPlay(with input: String) {
        inputText = input
        self.synthesisToSpeaker()
    }
    
    func synthesisToSpeaker() {
        
        if inputText.isEmpty {
            return
        }
        
        let url = URL(string: "https://speech-functions-cfgfd3fyb8gmhwbj.z01.azurefd.net/api/synthesize")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var parameters: [String: Any] = ["text": inputText, "voice": speakerName]
        if rate != nil {
            parameters["rate"] = rate
        }
        if pitch != nil {
            parameters["pitch"] = pitch
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

//            guard (200 ... 299) ~= response.statusCode else {
//                print("statusCode should be 2xx, but is \(response.statusCode)")
//                print("response = \(response)")
//                return
//            }
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any], let file = responseJSON["file"] as? String {
//                DispatchQueue.main.async {
                    self.playSound(file: file)
//                }
            }
        }
        task.resume()
    }

    func playSound(file: String) {
        let dataDecoded = Data(base64Encoded: file)!
        let audioSession = AVAudioSession.sharedInstance()
        let audioPlayer = try! AVAudioPlayer(data: dataDecoded)
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true)
            
            audioPlayer.prepareToPlay()
            print("84")
            audioPlayer.play()
            print("87 \(audioPlayer.isPlaying)")
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }
        
        do {
           
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        
        
//        audioEngine.connect(playerNode, to: audioEngine.mainMixerNode, format: audioFormat)
//        playerNode.scheduleFile(audioFile, at: nil) {
//            audioEngine.stop()
//            audioEngine.reset()
//        }
//        do {
//            try audioEngine.start()
//        } catch {
//            print("Error starting audio engine: \(error.localizedDescription)")
//        }
//        playerNode.play()
    }
}
