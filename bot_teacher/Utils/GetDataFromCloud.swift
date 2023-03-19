//
//  GetDataFromCloud.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/17.
//

import Foundation
import FirebaseFirestore

class MainPageDataUtils: ObservableObject {
    
    @Published var showTeacherListView = false
    var numOfCompletion = 0
    let db = Firestore.firestore()
    var docRef: DocumentReference!
    var collectionRef: CollectionReference!
    let numToComplete = 7
    
    func addInMainThread() {
        DispatchQueue.main.async {
            self.numOfCompletion += 1
            self.showTeacherListView = self.numOfCompletion == self.numToComplete
            print("24: \(self.numOfCompletion)")
        }
    }
    

    // MARK: get all teacher, separated by languages: [LanguageTeacherModel]
    func convertDictionaryToLanguageTeacherModel(_ document: [String: Any]) -> LanguageTeacherModel {
        let language = document["language"] as? String ?? ""
        let icon = document["icon"] as? String ?? ""
        let peopleDicts = document["peoples"] as? [[String: Any]] ?? []
        var peoples: [LanguageTeacherModel.PeopleModel] = []

        for peopleDict in peopleDicts {
            let name = peopleDict["name"] as? String ?? ""
            let image = peopleDict["image"] as? String ?? ""
            let people = LanguageTeacherModel.PeopleModel(name: name, image: image)
            peoples.append(people)
        }

        let model = LanguageTeacherModel(language: language, icon: icon, peoples: peoples)
        return model
    }

    func fetchLanguageTeacherModels() {
        collectionRef = db.collection("languageTeacherModels")
        collectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getti: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    var dict = document.data()
                    print("dict")
                    ltmodels.append(self.convertDictionaryToLanguageTeacherModel(dict))
                }
                self.addInMainThread()
                print("ltmodels \(ltmodels)")
            }
        }
       
    }

    // MARK: get configs from cloud
    func fetchConfig(with configVersion: String) {
        docRef = Firestore.firestore().collection("config").document(configVersion)
        docRef.getDocument { configSnapshot, error in
            if error != nil {
                print("error fetching config")
            } else {
                guard let configSnapshot = configSnapshot, configSnapshot.exists else { return }
                let data = configSnapshot.data()!
                AZURE_KEY = data["AZURE_KEY"] as? String ?? ""
                AZURE_REGION = data["AZURE_REGION"] as? String ?? ""
                OPENAI_KEY = data["OPENAI_KEY"] as? String ?? ""
                conversationTime = data["CONVERSATION_TIME"] as? Int ?? 600
                self.addInMainThread()
                print("config: \(AZURE_KEY), \(AZURE_REGION)")
            }
        }
    }

    // MARK: get all teachers
    func convertDocumentToTeacher(_ languageDict: [String: Any]) -> Teacher {
        let name = languageDict["name"] as? String ?? ""
        let speakerName = languageDict["speaker_name"] as? String ?? ""
        let languageIdentifier = languageDict["language_identifier"] as? String ?? ""
        let language = languageDict["language"] as? String ?? ""

        let teacher = Teacher(name: name, speakerName: speakerName, languageIdentifier: languageIdentifier, language: language)
       

        return teacher
    }
    
    func fetchTeachers() {
        collectionRef = Firestore.firestore().collection("teachers")
        collectionRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let dict = document.data()
                    teachers[document.documentID] = self.convertDocumentToTeacher(dict)
                }
                self.addInMainThread()
                print("teacher: \(teachers)")
            }
        }
    }

    // MARK: get all constrains
    func fetchConstrains() {
        collectionRef = Firestore.firestore().collection("constrains")
        collectionRef.getDocuments { configSnapshot, error in
            if error != nil {
                print("error fetching constrain")
            } else {
                for document in configSnapshot!.documents {
                    let dict = document.data()
                    constrains[document.documentID] = dict["constrain"] as? String ?? ""
                }
                self.addInMainThread()
                print("constrains: \(constrains)")
                
            }
        }

    }

    // MARK: get all initPrompt
    func fetchInitPrompt() {
        collectionRef = Firestore.firestore().collection("init_prompt")
        collectionRef.getDocuments { configSnapshot, error in
            if error != nil {
                print("error fetching init prompts")
            } else {
                for document in configSnapshot!.documents {
                    let dict = document.data()
                    initPrompts[document.documentID] = dict["prompt"] as? String ?? ""
                }
                self.addInMainThread()
                print("initptompt: \(initPrompts)")
                
            }
        }
    }

    // MARK: get all filterWords
    func fetchFilterWords() {
        collectionRef = Firestore.firestore().collection("filter_words")
        collectionRef.getDocuments { configSnapshot, error in
            if error != nil {
                print("error fetching filter_words")
            } else {
                for document in configSnapshot!.documents {
                    let dict = document.data()
                    filterWords[document.documentID] = dict["words"] as? String ?? ""
                }
                self.addInMainThread()
                print("filterWords: \(filterWords)")
                
            }
        }
        
    }

    // MARK: get all languages
    func fetchLanguages(with languageVersion: String) {
        docRef = Firestore.firestore().collection("languages").document(languageVersion)
        docRef.getDocument { configSnapshot, error in
            if error != nil {
                print("error fetching languages")
            } else {
                guard let configSnapshot = configSnapshot, configSnapshot.exists else { return }
                let data = configSnapshot.data()!
                languages = data["languages"] as? [String] ?? []
//                print("languages: \(languages)")
                self.addInMainThread()
            }
        }
    }
    
    init() {
        loadMainPageData()
    }
    
    func loadMainPageData() {

        fetchConfig(with: "config_v1")
        fetchTeachers()
        fetchLanguages(with: "languages_v1")
        fetchLanguageTeacherModels()
        fetchConstrains()
        fetchInitPrompt()
        fetchFilterWords()
        
        
    }

}


