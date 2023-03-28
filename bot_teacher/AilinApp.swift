import SwiftUI
import AVFAudio
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
//    Auth.auth().useEmulator(withHost:"localhost", port:9099)
//    let db = Firestore.firestore()
      
    return true
  }
    func applicationDidEnterBackground(_ application: UIApplication) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            print("Error pausing audio session: \(error.localizedDescription)")
        }
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Error resuming audio session: \(error.localizedDescription)")
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            print("Error stopping audio session: \(error.localizedDescription)")
        }
    }



}

@main
struct AilinApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  var body: some Scene {
    WindowGroup {
      NavigationView {
        AuthenticatedView {
          Image("ailin")
            .resizable()
            .frame(width: 100 , height: 100)
            .foregroundColor(Color(.systemPink))
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .clipped()
            .padding(4)
            .overlay(Circle().stroke(Color.black, lineWidth: 2))
          Text("Welcome to Ailin!")
            .font(.title)
          Text("You need to be logged in to use this app.")
        } content: {
          Spacer()
        }
      }
    }
  }
}
