//
//  USquat_iosApp.swift
//  USquat-ios
//
//  Created by Kelly Pham on 1/13/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct USquat_iosApp: App {
    
    // Attach AppDelegate to SwiftUI
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            
        }
    }
}

// TODO: Create App Delegates....
class AppDelegate:
    NSObject, UIApplicationDelegate, GIDSignInDelegate, ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var username = ""
    
    // See Firebase swift documentation at
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Set Google Signin Delegates
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self

        return true
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      
        guard let user = user else {
            print((error?.localizedDescription)!)
            return
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: user.authentication.idToken, accessToken: user.authentication.accessToken)
        
        // Authenticate with Firebase using credentials
        Auth.auth().signIn(with: credential) { (result,err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            
            // If login successfully
            self.isLoggedIn = true
            self.username = (result?.user.displayName)!
            print(self.username)
            
           
    }
    
}
}
