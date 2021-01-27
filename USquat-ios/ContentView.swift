//
//  ContentView.swift
//  USquat-ios
//
//  Created by Kelly Pham on 1/13/21.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    // Passing userInfo as global
    @EnvironmentObject var info: AppDelegate
    
    var body: some View {
        LoginView()
        
    }
}

// Splash View
struct SplashView: View {
    @State var isActive:Bool = false
    
    var body: some View{
        VStack{
            if self.isActive{
                LoginView()
            } else {
                Text("This is a splash screen")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


// Login View
struct LoginView : View {
    
    // Passing userInfo as global
    @EnvironmentObject var info: AppDelegate

    // declarative properties
    @State var email = ""
    @State var password = ""
    
    
    var body: some View{
        
        if (info.isLoggedIn){
            HomeView()
        } else {
        ZStack {
            Color.black.opacity(0.03).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                // Logo
                HStack (alignment: .top, spacing: 0) {
                    Image("squat_logo")
                        .resizable()
                        .frame(width: 400, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                
                // LOGIN SECTION
                VStack (alignment: .leading) {
                    Text("Login")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    
                    // Email field
                    Text("Email")
                        .padding(.top)
                    
                    VStack {
                        TextField("Email",
                                  text:self.$email)
                            .disableAutocorrection(true)
                        Rectangle()
                            .fill(self.email == "" ? Color.black.opacity(0.1) : Color("Color1"))
                            .frame(height: 2)
                    }
                    .padding(.horizontal)
                    // Pasword fields
                    Text("Password")
                    VStack {
                        SecureField("Password",
                                    text:self.$password)
                            .disableAutocorrection(true)
                        Rectangle()
                            .fill(self.password == "" ? Color.black.opacity(0.1) : Color("Color1"))
                            .frame(height: 2)
                    }
                    .padding(.horizontal)
                    HStack {
                        Button(action: {
                            
                        }){
                            Text("Forget Password?")
                                .padding()
                        }
                    }
                    
                    // SIGNIN Button
                    HStack {
                        Button(action: {
                            
                        }){
                            Text("SIGNIN")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(LinearGradient(gradient: .init(colors: [Color("Color1"), Color("Color2")]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                                .cornerRadius(10)
                            
                        }
                    }
                    
                }
                .overlay(Rectangle().stroke(Color.black.opacity(0.03),lineWidth: 1).shadow(radius: 2))
                .padding()
                .background(Color.white)
                .padding(.horizontal)
                .padding(.top,-100)
                
                
                
                // Social media
                HStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 5)
                    Text("Or With")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Rectangle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 5)
                }
                .padding()
                // Social Media Icon
                HStack (alignment: .center) {
                    
                    // Google Icon
                    Button(action: {
                        
                        // Google SIGNIN
                        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.first?.rootViewController
                        GIDSignIn.sharedInstance()?.signIn()
                        
                       
                    }) {
                        Image("google")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)


                    }
                    
               
                    
                    
                    
                    // Facebook Icon
                    Button(action: {
                        // TODO: Facebook SIGNIN
                        
                    }) {
                        Image("facebook")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                    
                    // Twitter Icon
                    Button(action: {
                        // TODO: Twitter SIGNIN
                    }) {
                        Image("twitter")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(5)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.bottom)
                
                // New User Sign in
                HStack {
                    Text("New User?")
                        .padding(2)
                    Button(action: {
                    }) {
                        Text("Sign in")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.top)
                
                Spacer()
                
                
            }
            
        }
        }
        
    }
}








struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
