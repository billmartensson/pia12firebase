//
//  ContentView.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-20.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var addtodo = ""
        
    @State var todoitems = [Todoitem]()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Todo...", text: $addtodo)
                
                Button(action: {
                    savetodo()
                }, label: {
                    Text("Add")
                })
            }
            
            List {
                ForEach(todoitems, id: \.self.title) { todo in
                    HStack {
                        Text(todo.title)
                        
                        Spacer()
                        if todo.isdone {
                            Text("KLAR")
                        } else {
                            Text("INTE KLAR")
                        }
                    }
                    
                    
                }
            }
            
        }
        .padding()
        .onAppear() {
            //dofbstuff()
            loadtodo()
        }
    }
    
    func savetodo() {
        
        if addtodo == "" {
            // VARNA TOMT
            
            return
        }
        
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        var todothing = [String : Any]()
        todothing["todotitle"] = addtodo
        todothing["tododone"] = false

        ref.child("todolist").childByAutoId().setValue(todothing)
        
        loadtodo()

    }

    func loadtodo() {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        ref.child("todolist").getData(completion: { error, snapshot in
            /*
            if let thetodo = snapshot?.value as? String {
                addtodo = thetodo
            }
            */
            
            var allthetodo = [Todoitem]()

            for todochild in snapshot!.children {
                let childsnap = todochild as! DataSnapshot
                
                print("EN TODO SAK")
                
                
                if let thetodo = childsnap.value as? [String : Any] {
                    
                    var temptodo = Todoitem()
                    temptodo.title = thetodo["todotitle"] as! String
                    temptodo.isdone = thetodo["tododone"] as! Bool

                    allthetodo.append(temptodo)
                }
            }
            
            todoitems = allthetodo
            
        })
        
        
    }

    
    func dofbstuff() {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        //ref.child("fruit").setValue("Banan")
        
        ref.child("fruit").getData(completion: { error, snapshot in
            var thefruit = snapshot?.value as! String
            
            print("THE FRUIT IS: " + thefruit)
        })
    }
    
    
}

#Preview {
    ContentView()
}


class Todoitem {
    var title = ""
    var isdone = false
    
    
}
