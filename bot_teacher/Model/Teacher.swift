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
    var identifier : String
    
}

func initTeacher() -> Teacher {
    return Teacher(name: "", color: .white, speakerName: "en-US-JennyNeural", rate: 0.5, pitchMultiplier: 0.6, postUtteranceDelay: 0.7, volume: 0.5, identifier: "com.apple.ttsbundle.Samantha-compact")
}


let teachers: [Teacher] = [
    Teacher(name: "Kim Kardashian",color: .blue, speakerName: "en-US-JennyNeural", identifier: "com.apple.ttsbundle.siri_female_en-US_compact"),
    Teacher(name: "Steve Jobs", color: .systemMint, speakerName: "en-US-TonyNeural", identifier: "com.apple.speech.synthesis.voice.Fred"),
    Teacher(name: "Donald Trump", color: .systemPink, speakerName: "en-US-DavisNeural", identifier: "com.apple.ttsbundle.siri_male_en-US_compact")
]
