//
//  EnvironmentValues.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/15.
//

import Foundation

var languaues = ["English", "French", "Portuguese", "Chinese", "German"]

struct LanguageTeacherModel: Hashable {
    var language: String
    var icon: String
    var peoples:[PeopleModel]
    struct PeopleModel: Hashable {
        var name: String
        var image: String
    }
    init(language: String, icon: String, peoples: [PeopleModel]) {
        self.language = language
        self.icon = icon
        self.peoples = peoples
    }
    

    init() {
        self.language = ""
        self.icon = ""
        self.peoples = []
    }
        
}

var ltmodels : [LanguageTeacherModel] = [.init(language: "English", icon: "English", peoples: [.init(name: "Steve Jobs", image: "Steve Jobs"),
                                                                                               .init(name: "Kim Kardashian", image: "Kim Kardashian")]),
                                         .init(language: "French", icon: "French", peoples: [.init(name: "Zinadine Zidane", image: "Zinadine Zidane")])]

var conversationTime = 600 // 10 mins
// language: constrain
var constrains : [String: String] = ["English":"(responds in 2 sentences and sometimes ask a question)",
                                     "French": "(répondre en 2 phrases et parfois poser une question)"]

// init prompt in different language
var initPrompt : [String: String] = ["English": "Impersonate", "French": "emprunter l'identité"]

var filterWords: [String: String] = ["English": "as an AI language model", "French": "modèle de langue AI"]

struct Teacher {
    let name: String
    let speakerName: String
    let languageIdentifier: String
    let language: String
}

func initTeacher() -> Teacher {
    return Teacher(name: "", speakerName: "en-US-JennyNeural", languageIdentifier: "en-US", language: "English")
}


var teachers: [String: Teacher] = [
    "Kim Kardashian": Teacher(name: "Kim Kardashian", speakerName: "en-US-JennyNeural", languageIdentifier: "en-US", language: "English"),
    "Steve Jobs": Teacher(name: "Steve Jobs", speakerName: "en-US-TonyNeural", languageIdentifier: "en-US", language: "English"),
    "Donald Trump": Teacher(name: "Donald Trump", speakerName: "en-US-DavisNeural", languageIdentifier: "en-US", language: "English"),
    "Zinadine Zidane": Teacher(name: "Zinadine Zidane", speakerName: "fr-FR-AlainNeural", languageIdentifier: "fr-FR", language: "French")
]



