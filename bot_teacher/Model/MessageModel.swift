//
//  MessageModel.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/6.
//

import Foundation
import UIKit

enum MessageType {
    case Sender
    case Response
        
}

struct MessageModel {
    let messageType: MessageType
    let image: String?
    let content: String
}

var messages: [MessageModel] = [
    .init(messageType: .Sender, image: nil, content: "i send first"),
    .init(messageType: .Response, image: "Steve Jobs", content: "first response"),
    .init(messageType: .Sender, image: nil, content: "i send 2"),
    .init(messageType: .Response, image: "Steve Jobs", content: "2 response"),
    .init(messageType: .Sender, image: nil, content: "i send 3"),
    .init(messageType: .Response, image: "Steve Jobs", content: "3 response")

]

