//
//  Teacher.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/4.
//

import Foundation
import UIKit
import AVFoundation

struct Teacher {
    let name: String
    let color: UIColor
    let speakerName: String
    var rate : Float = 0.5
    var pitchMultiplier : Float = 0.6
    var postUtteranceDelay : Double = 0.7
    var volume : Float = 0.8
    
}

func initTeacher() -> Teacher {
    return Teacher(name: "", color: .white, speakerName: "en-US-JennyNeural", rate: 0.5, pitchMultiplier: 0.6, postUtteranceDelay: 0.7, volume: 0.5)
}


let teachers: [String: Teacher] = [
    "Kim Kardashian": Teacher(name: "Kim Kardashian",color: .blue, speakerName: "en-US-JennyNeural"),
    "Steve Jobs": Teacher(name: "Steve Jobs", color: .systemMint, speakerName: "en-US-TonyNeural"),
    "Donald Trump": Teacher(name: "Donald Trump", color: .systemPink, speakerName: "en-US-DavisNeural")
]

