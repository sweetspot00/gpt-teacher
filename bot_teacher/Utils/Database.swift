//
//  EnvironmentValues.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/15.
//

import Foundation

let language_identifier : [String: String] = ["English": "en-US", "France":"fr-fr", "Portuguese": "po-se"]
let languaues = ["English", "France", "Portuguese", "Chinese", "German"]

struct LanguageTeacherModel: Hashable {
    var language: String
    var icon: String
    var peoples:[PeopleModel]
    struct PeopleModel: Hashable {
        var name: String
        var image: String
    }
}

let ltmodels : [LanguageTeacherModel] = [.init(language: "English", icon: "English", peoples: [.init(name: "Steve Jobs", image: "Steve Jobs"),
                                                                                               .init(name: "Kim Kardashian", image: "Kim Kardashian")]),
                                         .init(language: "Franch", icon: "Franch", peoples: [.init(name: "Donald Trump", image: "Donald Trump")])]

let conversationTime = 600 // 10 mins
// language: constrain
let constrains : [String: String] = ["English":"(responds in 2 sentences and sometimes ask a question)"]

// init prompt in different language
let initPrompt : [String: String] = ["English": "Impersonate"]

let filterWords: [String: String] = ["English": "as an AI language model"]



