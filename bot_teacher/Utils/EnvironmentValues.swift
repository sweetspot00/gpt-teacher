//
//  EnvironmentValues.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/15.
//

import Foundation

let numbers_of_languages = 5

let OPENAI_KEY = "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"

let AZURE_KEY = "e988f66034084693946966821031c9db"

let AZURE_REGION = "southeastasia"

let language_identifier : [String: String] = ["English": "en-US", "France":"fr-fr", "Portuguese": "po-se"]
let languaues = ["English", "France", "Portuguese", "Chinese", "German"]

let imagesArray1 = ["Steve Jobs", "Kim Kardashian", "Donald Trump","Elon Musk"]

let imagesArray2 = [ "Kim Kardashian", "Donald Trump"]

let imagesArray3 = ["Steve Jobs","Donald Trump"]

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



