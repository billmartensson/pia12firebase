//
//  StartView.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-23.
//

import SwiftUI
import Firebase

struct StartView: View {
    
    @State var isloggedin : Bool?
    
    var body: some View {
        VStack {
            if isloggedin == nil {
                Text("Loading...")
            }
            if isloggedin == true {
                ContentView()
            }
            if isloggedin == false{
                LoginView()
            }
        }
        .onAppear() {
            TodoAPI().laddabilder(imagenumber: 0)
            
            var handle = Auth.auth().addStateDidChangeListener { auth, user in
              
                if Auth.auth().currentUser == nil {
                    isloggedin = false
                } else {
                    isloggedin = true
                    print(Auth.auth().currentUser?.uid)
                }
                
            }
            
            
            
        }
    }
}

#Preview {
    StartView()
}
