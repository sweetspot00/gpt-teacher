//
//  ContentView.swift
//  ChatTest
//
//  Created by Federico on 20/11/2021.
//

import SwiftUI
import OpenAISwift
import AVFoundation
import Speech


struct ChatView: View {
    
    @ObservedObject var speechDelegateClass = SpeechRecognizeDelegateClass()
    var chatTeacher: Teacher
    var userName: String
    let constrain = "responds in 2 sentences and sometimes ask a question"
    @State var client: OpenAISwift
    @State var messagesModels: [MessageModel] = []
    @State var isRecording: Bool = false
    @State var allowRecord: Bool = true
    @State var isInit: Bool = true
    @State var finalInput : [ChatMessage] = []
    @State var userSpeechMessage = ""
    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
//    @State private var delegate = SpeechRecognizerDelegate()
    @State var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    @State var recognitionTask: SFSpeechRecognitionTask?
    
    
    private let audioEngine = AVAudioEngine()
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
//                NavigationView {
                    VStack {
                        Text("\(chatTeacher.name)").font(.title).bold()
                    }
//                    .navigationBarTitle("Title")
//                }
        VStack {
            HStack {
                
                Image(chatTeacher.name)
                    .resizable()
                    .font(.system(size: 30))
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                
            }
            ScrollView {
                ForEach($messagesModels) { $messageModel in
                    MessageCellView(messageModel: messageModel)
                        .rotationEffect(.degrees(180))
                }
                .rotationEffect(.degrees(180))
                .padding()
            }
            
            VStack {
                Button(action: {

                    if (!isRecording) {
                        do {
                            try startRecording()
                        } catch {
                            // TODO: - pop up error msg
                            print("speech not available")
                        }
                    } else {
                        // stop audio
                        if audioEngine.isRunning {
                            audioEngine.stop()
                            audioEngine.inputNode.removeTap(onBus: 0)
                            recognitionRequest?.endAudio()
                        }
                        // MARK: -stop recording: send message to box


                    }
                    isRecording.toggle()
                    userSpeechMessage = ""
                       }) {
                           Image(systemName: isRecording ? "waveform.circle" : "waveform.circle.fill")
                               .resizable()
                               .frame(width: 80, height: 80)
//                               .foregroundColor(isRecording ? .red : .green)
                       }
            }
        }.onAppear {
            finalInput.append(initPrompt())
//            speechDelegateClass.setValue(with: isRecording)
//            speechRecognizer.delegate = speechDelegateClass
//            client.setup()
            
//            getGPTChatResponse(client: client, input: [initPrompt()], completion: { _ in
                
//                result in
//                let response = result.trimmingCharacters(in: .whitespacesAndNewlines)
//                messagesModels.append(MessageModel(id: UUID(),
//                                                   messageType: .Response,
//                                                   content: response))
//                playSpeech(with: response)
//            })
        }
        
        
    }
    
    func initPrompt() -> ChatMessage {
        let initMsg = "Impersonate \(chatTeacher.name)"
        let initCharMsg = createChatMessage(role: .Response, content: initMsg)
        return initCharMsg
    }
    
    func createChatMessage(role: MessageType, content: String) -> ChatMessage {
        switch role {
        case .Sender:
            return ChatMessage(role: .user, content: content)
        case .Response:
            return ChatMessage(role: .assistant, content: content)
        }
    }
    
    
    func sendMessage(message: String) {
        withAnimation {
            messagesModels.append(MessageModel(id: UUID(), messageType: .Sender, content: message))
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    // MARK: -GET GPT Response
                    let messageAddConstrain = message + constrain
                    let userMsg = createChatMessage(role: .Sender, content: messageAddConstrain)
                    finalInput.append(userMsg)
                    print("finalInput: \(finalInput)")
                    getGPTChatResponse(client: client, input: finalInput, completion: { result in
                        let response = result.trimmingCharacters(in: .whitespacesAndNewlines)
                        messagesModels.append(MessageModel(id: UUID(),
                                                           messageType: .Response,
                                                           content: response))
                        finalInput.append(createChatMessage(role: .Response, content: response + "impersonate \(chatTeacher.name)"))
                        playSpeech(with: response)
                    })
                    
                }
            }
        }
    }
    
    func playSpeech(with speechMessage: String) {
        
        // Configure the utterance.
        let utterance = AVSpeechUtterance(string: speechMessage)
        utterance.rate = chatTeacher.rate
        utterance.pitchMultiplier = chatTeacher.pitchMultiplier
        utterance.postUtteranceDelay = chatTeacher.postUtteranceDelay
        utterance.volume = chatTeacher.volume
        
        let voice = AVSpeechSynthesisVoice(identifier: chatTeacher.identifier)
        utterance.voice = voice
        
        synthesizer.speak(utterance)
        
    }
    // MARK: - speech recognization usage
    
    func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in

            
            if let result = result, result.isFinal, !isRecording {
                // Update the text view with the results.
                
                
                userSpeechMessage = result.bestTranscription.formattedString
//                print("speechMessage: \(userSpeechMessage)")
                let prompt  = "\(userName): \(userSpeechMessage)\n\(chatTeacher.name):"
                sendMessage(message: userSpeechMessage)
                
                
                print("Text \(result.bestTranscription.formattedString)")
            }
            
            if error != nil {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                isRecording = true
            }
        }
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        // Let the user know to start talking.
//        textView.text = "(Go ahead, I'm listening)"
        
    }
    
    func speechAuthorization() {
        
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    allowRecord = true
                    
                case .denied:
                    allowRecord = false
                    
                case .restricted:
                    allowRecord = false
                    
                case .notDetermined:
                    allowRecord = false
                    
                default:
                    allowRecord = false
                }
            }
        }
    }
//     MARK: SFSpeechRecognizerDelegate
    public func speechRecognizerDelegate(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            isRecording = true
//            recordButton.setTitle("Start Recording", for: [])
        } else {
            isRecording = false
//            recordButton.setTitle("Recognition Not Available", for: .disabled)
        }
    }

   
    
}


