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
            }
            
            VStack {
                Button(action: {

                    if (!isRecording) {

                        speechRecognizer.reset()
                        speechRecognizer.transcribe()

                    } else {

                        speechRecognizer.stopTranscribing()
                        // MARK: -stop recording: send message to box
                        let prompt  = "Alice: how are you? \n\(chatTeacher.name):"
                        sendMessage(prompt: prompt, message: "How are you?")
//                        sendMessage(message: "hello world")

                    }
                    isRecording.toggle()
                       }) {
                           Image(systemName: isRecording ? "waveform.circle" : "waveform.circle.fill")
                               .resizable()
                               .frame(width: 100, height: 100)
//                               .foregroundColor(isRecording ? .red : .green)
                       }
            }
        }.onAppear {
//            client.setup()
        }
        
        
    }
    
    func sendMessage(prompt: String, message: String) {
        withAnimation {
            messagesModels.append(MessageModel(id: UUID(), messageType: .Sender, content: message))
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                withAnimation {
                    // MARK: -GET GPT Response
                    getGPTResponse(client: client, input: prompt) { result in
                        let response = result.trimmingCharacters(in: .whitespacesAndNewlines)
                        messagesModels.append(MessageModel(id: UUID(),
                                                           messageType: .Response,
                                                           content: response))
                        playSpeech(with: response)
                    }
                    
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
    
   
    
}

