//
//  AzureSpeechRecognizer.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/22.
//
import MicrosoftCognitiveServicesSpeech
import Foundation
import AVFoundation

class AzureS2T: ObservableObject {
    
    enum RecognizerError: Error {
        case nilRecognizer
        case notAuthorizedToRecognize
        case notPermittedToRecord
        case recognizerIsUnavailable
        
        var message: String {
            switch self {
            case .nilRecognizer: return "Can't initialize speech recognizer"
            case .notAuthorizedToRecognize: return "Not authorized to recognize speech"
            case .notPermittedToRecord: return "Not permitted to record audio"
            case .recognizerIsUnavailable: return "Recognizer is unavailable"
            }
        }
    }
    private var audioEngine = AVAudioEngine()
    var transcript: String = ""
    var speechConfig: SPXSpeechConfiguration?
    let audioConfig = SPXAudioConfiguration()
    let recognizer: SPXSpeechRecognizer?
    var languageIdentifier: String = "en-US"
    
    
    init(languageIndentifier: String) {
        
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: AZURE_KEY, region: AZURE_REGION)
        } catch {
            print("error \(error) happened")
            speechConfig = nil
        }
        speechConfig?.speechRecognitionLanguage = languageIndentifier
        recognizer = try! SPXSpeechRecognizer(speechConfiguration: speechConfig!, audioConfiguration: audioConfig)
        self.languageIdentifier = languageIndentifier
        
        Task(priority: .background) {
            do {
                guard recognizer != nil else {
                    throw RecognizerError.nilRecognizer
                }
                guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                    throw RecognizerError.notPermittedToRecord
                }
            } catch {
                speakError(error)
            }
        }
        
    }
    
    private func speakError(_ error: Error) {
        var errorMessage = ""
        if let error = error as? RecognizerError {
            errorMessage += error.message
        } else {
            errorMessage += error.localizedDescription
        }
        transcript = "<< \(errorMessage) >>"
    }
    
    func startRecognize() {
        
        Task(priority: .background) {
            guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                throw RecognizerError.notPermittedToRecord
            }
            
            DispatchQueue.global(qos: .background).async {
                self.recognizeFromMic()
                
            }
        }
    }
    
    private func speak(_ message: String) {
        transcript = message
    }
        
    func recognizeFromMic() {
    
        recognizer!.addRecognizingEventHandler() { [self]reco, evt in
            transcript = evt.result.text ?? ""
            print("intermediate recognition result: \(evt.result.text ?? "(no result)")")
        }
        
        print("Listening...")
        
        let result = try! recognizer!.recognizeOnce()
        transcript = result.text ?? ""
        print("recognition result: \(result.text ?? "(no result)"), reason: \(result.reason.rawValue)")
        
        if result.reason != SPXResultReason.recognizedSpeech {
            let cancellationDetails = try! SPXCancellationDetails(fromCanceledRecognitionResult: result)
            print("cancelled: \(result.reason), \(cancellationDetails.errorDetails)")
            print("Did you set the speech resource key and region values?")
        }
    }
    
}
