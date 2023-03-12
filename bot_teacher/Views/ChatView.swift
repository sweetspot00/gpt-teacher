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
import Combine

struct ChatView: View {
    
    @ObservedObject var speechDelegateClass = SpeechRecognizeDelegateClass()
    var chatTeacher: Teacher
    var userName: String
    let constrain = "responds in 2 sentences and sometimes ask a question"
    var azureServeice = AzureSerivce()
    
    @State var client: OpenAISwift
    @State var messagesModels: [MessageModel] = []
    
    // trigger button
    @State var isRecording: Bool = false {
        didSet {
            controlLogic()
        }
    }
    
    
    
    
    // updated by Timer Thread
    @State var lastTimeStatus: Bool = false
    @State var allowRecord: Bool = true
    @State var isInit: Bool = true
    @State var finalInput : [ChatMessage] = []
    @State var userSpeechMessage = ""
    @State var buttonMsg =  ""
    @State var oldTranscript = ""
    @State var latestTranscript = ""
    @State var timer : Timer?
//    @State

    let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
//    @State private var delegate = SpeechRecognizerDelegate()
    @State var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    @State var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()
    
    // set empty time interval to 3s
    let sampleTime : Double = 2
    
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
                Text(buttonMsg)
                    .font(.system(size: 12, weight: .light, design: .serif))
            }

        }.onAppear {
            isRecording = true
            
            //            azureServeice.config(with: chatTeacher.name)
            
            // send init prompt
            
            finalInput.append(initPrompt())
            azureServeice.speakerName = chatTeacher.speakerName
            
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // MARK: Background Timer Thread
            timer = Timer.scheduledTimer(withTimeInterval: sampleTime, repeats: true, block: { _ in
                // check
                print(oldTranscript, latestTranscript)
                
                if (isRecording) {
                    if (oldTranscript != latestTranscript) {
                        
                        oldTranscript = latestTranscript
                    }
                    
                    else {
                        if (latestTranscript != "") {
                            print("timer running")
                            isRecording = false
                            print("isRecording should be false, real is \(isRecording)")
                            sendMessage(message: latestTranscript)
                        }
                        
                        
                    }
                } else {
                    
                }
            })
            
        }
        }.onDisappear {
            print("exit page")
            isRecording = false
            timer?.invalidate()
            do {
                try azureServeice.synthesizer.stopSpeaking()
            } catch {
                print("error stop speech")
            }
           
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
            return ChatMessage(role: .system, content: content)
        }
    }
    
    
    func sendMessage(message: String) {
        print("lastTimeStatus: \(lastTimeStatus), isRecording: \(isRecording)")
//        if (!message.isEmpty) {
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
                            
                            playSpeechViaAzure(with: response)
                        })
                        
                    }
                }
            }
//        }

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
    
    func playSpeechViaAzure(with speechMessage: String) {
        azureServeice.changeInputTextAndPlay(with: speechMessage)
        isRecording = true
        latestTranscript = ""
    }
    
    // MARK: - speech recognization usage
    
    func startRecording() throws {
        
        print("start recording")
        
            
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
            print("220")
            if let result = result {
                let msg = result.bestTranscription.formattedString

                print("Text \(result.bestTranscription.formattedString)")
                latestTranscript = msg
                print("update transcript")

                
            }

            if error != nil {

                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                isRecording = false
                    
            }
        }
        
        
        print("253")
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    /*
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

     */
    

    
    func controlLogic() {
        // status change
        if (lastTimeStatus != isRecording) {
           // start recording
            if (isRecording == true) {
                do {
                    lastTimeStatus = isRecording
                    buttonMsg = "Start Speaking, I'm listening..."
                    try startRecording()
                } catch {
                    // TODO: - pop up error msg
                    print("error: speech not available")
                }
                
            } else { // turn off recording
                buttonMsg = "waiting for response..."
                print("audioEngie status:\(audioEngine.isRunning)")
                lastTimeStatus = isRecording
                if audioEngine.isRunning {
                   audioEngine.stop()
                   audioEngine.inputNode.removeTap(onBus: 0)
                   recognitionRequest?.endAudio()
                }
            }
        } else {
//            //
//            buttonMsg = "waiting for response..."
//            lastTimeStatus = isRecording
//
//            if audioEngine.isRunning {
//               audioEngine.stop()
//               audioEngine.inputNode.removeTap(onBus: 0)
//               recognitionRequest?.endAudio()
//            }
        }
    }

    
    
   

}


