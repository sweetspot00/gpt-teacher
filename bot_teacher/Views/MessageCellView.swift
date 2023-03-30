//
//  SpeechToText.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/7.
//

import Foundation
import SwiftUI

struct MessageCellView: View {
    var messageModel: MessageModel
    @State private var isPresentingDetail = false
    
    var body: some View {
        if messageModel.messageType == .Sender {
            // User message styles
            HStack {
                Spacer()
                Text(messageModel.content)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            }
        } else {
            // Bot message styles
            HStack {
                Text(messageModel.content)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        isPresentingDetail = true
                    }
                    .sheet(isPresented: $isPresentingDetail) {
                        TranslationView(originalText: messageModel.content)
                    }
                Spacer()
            }
        }
    }
}
