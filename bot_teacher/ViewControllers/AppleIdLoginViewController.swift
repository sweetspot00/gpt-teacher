////
////  AppleIDLogInViewController.swift
////  bot_teacher
////
////  Created by niwanchun on 2023/3/13.
////
//
//import UIKit
//import AuthenticationServices
//import SwiftUI
//
//class AppleIdLoginViewController: UIViewController {
//
//    @IBOutlet weak var loginProviderStackView: UIStackView!
//    private let signInButton = ASAuthorizationAppleIDButton()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupProviderLoginView()
//    }
//
////    override func viewDidAppear(_ animated: Bool) {
////        super.viewDidAppear(animated)
////        performExistingAccountSetupFlows()
////    }
//
//    /// - Tag: add_appleid_button
//    func setupProviderLoginView() {
//        self.view.backgroundColor = .white
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//        authorizationButton.frame = CGRect(x: 0, y: 0, width: 250, height: 50)
//        authorizationButton.center = view.center
//        self.view.addSubview(authorizationButton)
//    }
//
//    // - Tag: perform_appleid_password_request
//    /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
//    func performExistingAccountSetupFlows() {
//        // Prepare requests for both Apple ID and password providers.
//        let requests = [ASAuthorizationAppleIDProvider().createRequest(),
//                        ASAuthorizationPasswordProvider().createRequest()]
//
//        // Create an authorization controller with the given requests.
//        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//
//    /// - Tag: perform_appleid_request
//    @objc
//    func handleAuthorizationAppleIDButtonPress() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//}
//
//extension AppleIdLoginViewController: ASAuthorizationControllerDelegate {
//    /// - Tag: did_complete_authorization
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
//            self.saveUserInKeychain(userIdentifier)
//
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
////            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//
//            // jump to main page
//            self.jumpToMainPage()
//
//
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//
//        default:
//            break
//        }
//    }
//
//    private func saveUserInKeychain(_ userIdentifier: String) {
//        do {
//            try KeychainItem(service: "com.example.apple-samplecode.juice", account: "userIdentifier").saveItem(userIdentifier)
//        } catch {
//            print("Unable to save userIdentifier to keychain.")
//        }
//    }
//
//    private func jumpToMainPage() {
//
//        let username = "sample"
//        let mainPageView = UIHostingController(rootView: TeacherListView(userName: "Sample"))
//        addChild(mainPageView)
//        view.addSubview(mainPageView.view)
//        mainPageView.view.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalToSuperview()
//            make.right.equalToSuperview()
//            make.bottom.equalToSuperview()
//        }
//    }
//
//    private func showPasswordCredentialAlert(username: String, password: String) {
//        let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
//        let alertController = UIAlertController(title: "Keychain Credential Received",
//                                                message: message,
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alertController, animated: true, completion: nil)
//    }
//
//    /// - Tag: did_complete_error
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        // Handle error.
//        print("authentication failed")
//    }
//}
//
//extension AppleIdLoginViewController: ASAuthorizationControllerPresentationContextProviding {
//    /// - Tag: provide_presentation_anchor
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//}
//
//
