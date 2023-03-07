//
//  SpeechToText.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/7.
//

import Foundation
import SwiftUI

@ViewBuilder func getMessageCellView(with messageModel: MessageModel) -> some View {

    if (messageModel.messageType == MessageType.Sender) {
        let newMessage = messageModel.content
        // User message styles
        HStack {
            Spacer()
            Text(newMessage)
                .padding()
                .foregroundColor(Color.white)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
        }
    } else {
        
        //  Bot message styles
        HStack {
            Text(messageModel.content)
                .padding()
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            Spacer()
        }
    }
}


struct MessageCellView: View {
    
    @State var messageModel: MessageModel
    var body: some View {
        getMessageCellView(with: messageModel)
    }
    
}
