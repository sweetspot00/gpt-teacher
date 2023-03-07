//
//  ContentView.swift
//  ChatTest
//
//  Created by Federico on 20/11/2021.
//

import SwiftUI
import OpenAISwift
import AVFoundation

struct ChatView: View {
    var chatTeacher: Teacher
    @State var client: OpenAISwift
    @State var messagesModels: [MessageModel] = []
    @State var isRecording: Bool = false
    @State var messages: [String] = ["Have a chat with Steve Jobs!"]
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    // Create a speech synthesizer.
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        //        NavigationView {
        //            VStack {
        //                Text("My View")
        //            }
        //            .navigationBarTitle("Title")
        //        }
        VStack {
            HStack {
                
                Image(chatTeacher.name)
                    .resizable()
                    .font(.system(size: 26))
                    .foregroundColor(Color.blue)
                    .aspectRatio(contentMode: .fit)
                
            }
            
            ScrollView {
                ForEach($messagesModels) { $messageModel in
                    MessageCellView(messageModel: messageModel)
                        .rotationEffect(.degrees(180))
                }
                .rotationEffect(.degrees(180))
                .padding()
            }.onAppear {
                getGPTResponse(client: client, input: "test1") { result in
                    print(result)
                }
            }
            
            VStack {
                Button(action: {

                    if (!isRecording) {

                        speechRecognizer.reset()
                        speechRecognizer.transcribe()

                    } else {

                        speechRecognizer.stopTranscribing()
                        // MARK: -stop recording: send message to box
                        let prompt  = "Alice: \(speechRecognizer.transcript)\n\(chatTeacher.name):"
//                        sendMessage(message: prompt)
                        sendMessage(message: "test")

                    }
                    isRecording.toggle()
                       }) {
                           Image(systemName: isRecording ? "waveform.circle" : "waveform.circle.fill")
                               .resizable()
                               .frame(width: 100, height: 100)
//                               .foregroundColor(isRecording ? .red : .green)
                       }
            }
        }
        
    }
    
    func sendMessage(message: String) {
        withAnimation {
            messagesModels.append(MessageModel(id: UUID(), messageType: .Sender, content: message))
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    // MARK: -GET GPT Response
                    getGPTResponse(client: client, input: message) { result in
                        messagesModels.append(MessageModel(id: UUID(),
                                                           messageType: .Response,
                                                           content: result))
                        playSpeech(with: result)
                    }
                    
                }
            }
        }
    }
    
    func playSpeech(with speechMessage: String) {
        
        // Configure the utterance.
        let utterance = AVSpeechUtterance(string: speechMessage)
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8
        
        // Retrieve the British English voice.
        let voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        // Assign the voice to the utterance.
        utterance.voice = voice
        
        synthesizer.speak(utterance)
        
    }
    
   
    
}

