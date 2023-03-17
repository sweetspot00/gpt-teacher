//
//  GetDataFromCloud.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/17.
//

import Foundation
import FirebaseFirestore

class MainPageDataUtils {

    var docRefLanguageTeachers: DocumentReference = Firestore.firestore().collection("language_teachers").document("language_teachers_v1")
    var docRefConfig: DocumentReference = Firestore.firestore().collection("config").document("config_v1")
    var docRefTeachers: DocumentReference = Firestore.firestore().collection("characters").document("characters_v1")
    
    var docRef: DocumentReference!

    // MARK: get all teacher, separated by languages: [LanguageTeacherModel]
    func convertDictionaryToLanguageTeacherModelArray(_ dictionary: [String: Any]) -> [LanguageTeacherModel] {
        var models: [LanguageTeacherModel] = []
        if let languages = dictionary["languages"] as? [[String: Any]] {
            for language in languages {
                if let languageName = language["language"] as? String,
                   let icon = language["icon"] as? String,
                   let peoples = language["peoples"] as? [[String: Any]] {
                    var peopleModels: [LanguageTeacherModel.PeopleModel] = []
                    for person in peoples {
                        if let name = person["name"] as? String,
                           let image = person["image"] as? String {
                            let personModel = LanguageTeacherModel.PeopleModel(name: name, image: image)
                            peopleModels.append(personModel)
                        }
                    }
                    let model = LanguageTeacherModel(language: languageName, icon: icon, peoples: peopleModels)
                    models.append(model)
                }
            }
        }
        return models
    }

    func fetchAllTeachers() {
        docRefLanguageTeachers.getDocument { docSnapshot, error in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else { return }
            let teachersByLanguage = docSnapshot.data()
            ltmodels = self.convertDictionaryToLanguageTeacherModelArray(teachersByLanguage ?? ["": ""])
        }
    }

    // MARK: get configs from cloud
    func fetchConfig() {
        docRefConfig.getDocument { configSnapshot, error in
            if error != nil {
                print("error fetching config")
            } else {
                guard let configSnapshot = configSnapshot, configSnapshot.exists else { return }
                let data = configSnapshot.data()!
                AZURE_KEY = data["AZURE_KEY"] as? String ?? ""
                AZURE_REGION = data["AZURE_REGION"] as? String ?? ""
                OPENAI_KEY = data["OPENAI_KEY"] as? String ?? ""
                conversationTime = data["CONVERSATION_TIME"] as? Int ?? 600
            }
        }
    }

    // MARK: get all teachers
    func fetchTeacher() {
        docRefTeachers.getDocument { configSnapshot, error in
            if error != nil {
                print("error fetching characters")
            } else {
                guard let configSnapshot = configSnapshot, configSnapshot.exists else { return }
                // TODO: convert json to teachers
            }
        }
    }

    // MARK: get all constrains
    func fetchConstrains() {
       docRef = Firestore.firestore().collection("constrains").document("constrains_v1")

    }

    // MARK: get all initPrompt
    func fetchInitPrompt() {
        docRef = Firestore.firestore().collection("init_prompts").document("init_prompts_v1")
    }

    // MARK: get all filterWords
    func fetchFilterWords() {
        docRef = Firestore.firestore().collection("filter_words").document("filter_words_v1")
    }

    // MARK: get all languages
    func fetchLanguages() {
        docRef = Firestore.firestore().collection("languages").document("languages_v1")
    }

    // MARK: get all language_identifier
    func fetchLanguageIdentifier() {
        docRef = Firestore.firestore().collection("language_identifier").document("language_identifier_v1")
    }

}


