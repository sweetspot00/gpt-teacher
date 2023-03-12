//
//  RecordingControllViewModel.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/10.
//

import Foundation

import Combine


class RecordingControlViewModel: ObservableObject {
    
    @Published var isRecording = false
    
//    func controlLogic() {
//        DispatchQueue.global(qos: .background).async {
//
//            if (isRecording) {
//                do {
////                    buttonMsg = "Start Speaking, I'm listening..."
//                    try startRecording()
//                } catch {
//                    // TODO: - pop up error msg
//                    print("speech not available")
//                }
//            } else {
//                // stop audio
//                buttonMsg = ""
//                if audioEngine.isRunning {
//                    audioEngine.stop()
//                    audioEngine.inputNode.removeTap(onBus: 0)
//                    recognitionRequest?.endAudio()
//                }
//
//            }
//            isRecording.toggle()
//            userSpeechMessage = ""
//
//        }
//    }
}
