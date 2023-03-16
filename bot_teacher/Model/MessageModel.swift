//
//  MessageModel.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import Foundation
import UIKit

enum MessageType: Codable {
    case Sender
    case Response
        
}

struct MessageModel: Codable, Hashable, Identifiable {
    
    let id: UUID
    var messageType: MessageType
    var content: String
    
    init(id: UUID, messageType: MessageType, content: String) {
        self.id = id
        self.messageType = messageType
        self.content = content
    }
    
    mutating func update(from message: String, messageType: MessageType) {
        self.content = message
        self.messageType = messageType
        
    }
}

