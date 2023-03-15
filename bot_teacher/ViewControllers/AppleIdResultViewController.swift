//
//  AppleIdResultViewController.swift
//  bot_teacher
//
//  Created by niwanchun on 2023/3/13.
//

import UIKit
import AuthenticationServices

class ResultViewController: UIViewController {
    
    @IBOutlet weak var userIdentifierLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdentifierLabel.text = KeychainItem.currentUserIdentifier
    }
    
    @IBAction func signOutButtonPressed() {
        // For the purpose of this demo app, delete the user identifier that was previously stored in the keychain.
        KeychainItem.deleteUserIdentifierFromKeychain()
        
        // Clear the user interface.
        userIdentifierLabel.text = ""
        givenNameLabel.text = ""
        familyNameLabel.text = ""
        emailLabel.text = ""
        
//        // Display the login controller again.
//        DispatchQueue.main.async {
//            self.showLoginViewController()
//        }
    }
}
