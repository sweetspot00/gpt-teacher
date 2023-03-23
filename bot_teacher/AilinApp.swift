import SwiftUI
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
