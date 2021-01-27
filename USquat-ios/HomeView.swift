//
//  HomeView.swift
//  USquat-ios
//
//  Created by Kelly Pham on 1/14/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct HomeView: View {
    
    // Passing userInfo as global
    @EnvironmentObject var info: AppDelegate
    var body: some View {
        
        ZStack {
         
            TabView{
                CameraViewController()
                    .tabItem {
                        Text("Camera")
                    }
                Gallery()
                    .tabItem {
                        Text("Gallery")
                    }
                Text("Logout section")
                Button(action: {
                    logOut()
                }) {
                    Text("SIGN OUT")
                }
                    .tabItem {
                        Text("Log out")
                    }
            }
        }
        
    }
    
    func logOut() {
        GIDSignIn.sharedInstance()?.signOut()
        try! Auth.auth().signOut()
        info.isLoggedIn = false
        print(info.isLoggedIn)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
