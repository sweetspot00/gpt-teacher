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
                VStack(alignment: .leading) {
                    Text(messageModel.content)
                    Button(action: {
                        isPresentingDetail = true
                    }) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 23, height: 23)
                            .overlay(
                                Image(systemName: "globe")
                                    .foregroundColor(.white)
                                    .font(.system(size: 13))
                            )
                    }
                    .sheet(isPresented: $isPresentingDetail) {
                        TranslationView(originalText: messageModel.content)
                    }
                    .padding(.top, 1)
                }
                .padding()
                .padding(.leading, 3)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .padding(.horizontal, 8)
            }
        }
    }
}
