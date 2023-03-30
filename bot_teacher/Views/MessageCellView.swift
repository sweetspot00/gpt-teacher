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
            ZStack(alignment: .bottomTrailing) {
                Text(messageModel.content)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                Button(action: {
                    isPresentingDetail = true
                }) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "globe")
                                .foregroundColor(.white)
                        )
                }
                .sheet(isPresented: $isPresentingDetail) {
                        TranslationView(originalText: messageModel.content)
                    }
                .padding(.bottom, 5)
            }
        }
    }
}
