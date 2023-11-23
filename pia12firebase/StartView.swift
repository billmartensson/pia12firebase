//
//  StartView.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-23.
//

import SwiftUI
import Firebase

struct StartView: View {
    
    @State var isloggedin = false
    
    var body: some View {
        VStack {
            if isloggedin {
                ContentView()
            } else {
                LoginView()
            }
        }
        .onAppear() {
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
