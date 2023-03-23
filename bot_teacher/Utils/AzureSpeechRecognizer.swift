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
    
    func startRecognize(languageIdentifier: String) {
        
        Task(priority: .background) {
            guard await AVAudioSession.sharedInstance().hasPermissionToRecord() else {
                throw RecognizerError.notPermittedToRecord
            }
            
            DispatchQueue.global(qos: .background).async {
                self.recognizeFromMic(languageIndentifier: languageIdentifier)
            }
        }
    }
        
    func recognizeFromMic(languageIndentifier: String) {
        
        var speechConfig: SPXSpeechConfiguration?
        do {
            try speechConfig = SPXSpeechConfiguration(subscription: AZURE_KEY, region: AZURE_REGION)
        } catch {
            print("error \(error) happened")
            speechConfig = nil
        }
        speechConfig?.speechRecognitionLanguage = languageIndentifier
        
        let audioConfig = SPXAudioConfiguration()
        
        let reco = try! SPXSpeechRecognizer(speechConfiguration: speechConfig!, audioConfiguration: audioConfig)
        
        reco.addRecognizingEventHandler() {reco, evt in
            print("intermediate recognition result: \(evt.result.text ?? "(no result)")")
        }
        
        print("Listening...")
        
        let result = try! reco.recognizeOnce()
        print("recognition result: \(result.text ?? "(no result)"), reason: \(result.reason.rawValue)")
        
        if result.reason != SPXResultReason.recognizedSpeech {
            let cancellationDetails = try! SPXCancellationDetails(fromCanceledRecognitionResult: result)
            print("cancelled: \(result.reason), \(cancellationDetails.errorDetails)")
            print("Did you set the speech resource key and region values?")
        }
    }
    
}
