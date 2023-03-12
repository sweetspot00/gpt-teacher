//
//  Trigger.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/12.
//

import Foundation

class Trigger {
    var callback: (() -> Void)?
    
    func trigger() {
        callback?()
    }
}
