//
//  ChatViewControllerExtension.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import UIKit
import AVKit
import AVFoundation
import SwiftUI
import Combine

extension ChatViewController {
    
    
    // MARK: speech to text

    /*
     1. listening time limit -> stop listening
     2. GPT's speech been played -> start listening
     */
    private func trigger() {
        
    }
    
    private func startRecognize() {
        self.recognizer.stopListening = false
    }
    
    private func stopRecognize() {
        self.recognizer.stopListening = true
    }
    
    // MARK: text to speech
    private func textToSpeech(input: String, rate: Float, language: String) {
        let utterance = AVSpeechUtterance(string: input)
        utterance.rate = rate
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        synthesizer.speak(utterance)
    }
}


