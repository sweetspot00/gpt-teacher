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
    
    var chatTeacherName: String // pass in
    @State var chatTeacher: Teacher? // get by teachers[chatTeacherName]
    var userName: String // pass in
    @State var language_identifier: String? // get from chatTeacher
    @State var sessionConstrain : String? // get from constrains[language]
    @State var sessionInitPrompt : String? // get from initPromt
    var azureServeice = AzureSerivce()
    
    
    @State var initResponse = ""
    
    @State var client : OpenAISwift?
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
    
    // MARK: conversation timer
    @State var timeRemaining = conversationTime
    @State var conversationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showingAlert = false
    
    @State var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    @State var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    @State var recognitionTask: SFSpeechRecognitionTask?
    @State var isPaused = false
    
    private let audioEngine = AVAudioEngine()
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()
    
    // set empty time interval to 3s
    let sampleTime : Double = 2
    
    var closeButtonClick: () -> ()
    
    var body: some View {
        
        ZStack {
            HStack {
                Button {
                    closeButtonClick()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .bold))
                }
                Spacer()
            }.padding([.horizontal], 15)
            
           
            VStack {
                Text("\(chatTeacherName)").font(.title).bold()
                Text("\(timeString(time: timeRemaining))")
                    .font(.subheadline)
                    .onReceive(conversationTimer) { _ in
                        if self.timeRemaining > 0 {
                            self.timeRemaining -= 1
                        }
                    }
            } // MARK: time to stop and quit page
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Time's up!"),
                    message: Text("Your progress will not be saved."),
                    dismissButton: .destructive(Text("Quit"), action: {
                        // handle quitting here
                        closeButtonClick()
                    })
                )
            }
            .onReceive(conversationTimer) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.conversationTimer.upstream.connect().cancel()
                    showingAlert = true
                }
            }
            
            
        }

        
        VStack {
            HStack {
                
                Image(chatTeacherName)
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
            
            VStack {
                Button(action: {
                    if isPaused {
                        isPaused.toggle()
                        conversationTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                        resumeSession()
                        buttonMsg = "Start Speaking, I'm listening..."
                    } else {
                        self.conversationTimer.upstream.connect().cancel()
                        isPaused.toggle()
                        stopSession()
                        buttonMsg = "Conversation Stopped"
                    }
                  }) {
                      if isPaused {
                          Text("Resume Conversation")
                              .foregroundColor(.white)
                      } else {
                          Text("Pause conversation")
                              .foregroundColor(.white)
                              .font(.headline)
                      }
                  }
                  .frame(width: CGFloat(300), height: CGFloat(40))
                  .background(Color("ailinPink"))
                  .cornerRadius(7)
                
            }

        }.onAppear {


            // get chatTeacher
            // TODO: chatTeacher = nil
//            DispatchQueue.main.async {
//                chatTeacher = initTeacher()
                self.chatTeacher = teachers[chatTeacherName]
//                print("176: \(teachers[chatTeacherName])")
//                print("174: \(teachers)")
                self.sessionConstrain = constrains[chatTeacher!.language]

                self.language_identifier = chatTeacher?.languageIdentifier
                speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: chatTeacher!.languageIdentifier))!
                self.sessionInitPrompt = initPrompts[chatTeacher!.language]
                print("sessionConstrain \(sessionConstrain), \(sessionInitPrompt), \(chatTeacher!.languageIdentifier)")
                sendInitMsgAndfilter()
//                sendInitMsg()
                buttonMsg = "Please wait for the session to start..."
    //            finalInput.append(initPrompt())
                azureServeice.speakerName = chatTeacher?.speakerName
//            }


            
            
            
            
            
        }.onDisappear {
            
            print("exit page")
            stopSession()
           
        }
        
    }
    

    
    func stopSession() {
        isRecording = false
        timer?.invalidate()
        timer = nil
        recognitionTask?.cancel()
        do {
            try azureServeice.synthesizer.stopSpeaking()
        } catch {
            print("error stop speech")
        }

    }
    
    func resumeSession() {
        startTimer()
        isRecording = true
    }
    
    func startTimer() {
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
    }
    // MARK: conversation time longest = 10 mins
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
   
    func sendInitMsgAndfilter() {
        let words = filterWords[chatTeacher!.language]
        
        func getInitResponse() {
            getGPTChatResponse(client: client!, input: [initPrompt(), createChatMessage(role: .Sender, content: "hello")], completion: { result in
                initResponse = result.trimmingCharacters(in: .whitespacesAndNewlines)
//                if initResponse != "" && !initResponse.lowercased().contains(words!.lowercased()) {
                    finalInput.append(initPrompt())
                    finalInput.append(createChatMessage(role: .Sender, content: "hello"))
                    finalInput.append(createChatMessage(role: .Response, content: initResponse))
//                    print("init final input: \(finalInput)")
                    isRecording = true
                    startTimer()
//                } else {
//                    client = APICaller().getClient()
//                    getInitResponse()
//                }
            })
        }
        
        getInitResponse()
    }


    
    
    func initPrompt() -> ChatMessage {
        let initMsg = sessionInitPrompt! + " " + chatTeacherName
//        print("initMsg:\(initMsg)")
        let initCharMsg = ChatMessage(role: .system, content: initMsg)
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
    
    
    func sendInitMsg() {
        getGPTChatResponse(client: client!, input: [initPrompt()], completion: { result in
            initResponse = result.trimmingCharacters(in: .whitespacesAndNewlines)
        })
    }
    
    func sendMessage(message: String) {
//        print("lastTimeStatus: \(lastTimeStatus), isRecording: \(isRecording)")
//        if (!message.isEmpty) {
            withAnimation {
                messagesModels.append(MessageModel(id: UUID(), messageType: .Sender, content: message))
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    withAnimation {
                        // MARK: -GET GPT Response
                        let messageAddConstrain = message + " " + sessionConstrain!
                        let userMsg = createChatMessage(role: .Sender, content: messageAddConstrain)
                        finalInput.append(userMsg)
                        print("finalInput: \(finalInput)")
                        getGPTChatResponse(client: client!, input: finalInput, completion: { result in
                            let response = result.trimmingCharacters(in: .whitespacesAndNewlines)
                            messagesModels.append(MessageModel(id: UUID(),
                                                               messageType: .Response,
                                                               content: response))
                            finalInput.append(createChatMessage(role: .Response, content: response))
                            
                            playSpeechViaAzure(with: response)
                        })
                        
                    }
                }
            }
//        }

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
//            print("220")
            if let result = result {
                let msg = result.bestTranscription.formattedString
//                print("Text \(result.bestTranscription.formattedString)")
                latestTranscript = msg
//                print("update transcript")
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
                if isPaused {
                    buttonMsg = "Conversation Stopped"
                } else {
                    buttonMsg = "waiting for response..."
                }
                
                print("audioEngie status:\(audioEngine.isRunning)")
                lastTimeStatus = isRecording
                if audioEngine.isRunning {
                   audioEngine.stop()
                   audioEngine.inputNode.removeTap(onBus: 0)
                   recognitionRequest?.endAudio()
                }
            }
        } else {
            // in case
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


