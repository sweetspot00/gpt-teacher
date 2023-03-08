//
//  SpeechRecognizerDelegate.swift
//  bot_teacher
//
//  Created by Vincy on 8/3/23.
//

import Foundation
import Speech

class SpeechRecognizeDelegateClass: NSObject, SFSpeechRecognizerDelegate, ObservableObject {
    
    @Published var isRecording: Bool
    
    override init() {
        isRecording = false
    }
    
    init(with value: Bool) {
        self.isRecording = value
    }
    
    public func setValue(with isRecording: Bool) {
        self.isRecording = isRecording
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            isRecording = true
        } else {
            isRecording = false
        }
    }
    
}
