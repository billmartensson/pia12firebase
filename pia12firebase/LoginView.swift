//
//  LoginView.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var loginemail = ""
    @State var loginpass = ""
    
    var body: some View {
        VStack {
            
            TextField("Email", text: $loginemail)

            TextField("Password", text: $loginpass)

            Button(action: {
                login()
            }, label: {
                Text("Login")
            })

            Button(action: {
                register()
            }, label: {
                Text("Register")
            })

            
            
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: loginemail, password: loginpass) { authResult, error in
          
            if error == nil {
                print("LOGIN OK")
            } else {
                print("LOGIN FAIL")
            }
            
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: loginemail, password: loginpass) { authResult, error in

            if error == nil {
                print("REGISTER OK")
            } else {
                print("REGISTER FAIL")
            }
            
        }
    }
}

#Preview {
    LoginView()
}
