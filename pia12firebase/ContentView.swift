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
            
    @StateObject var todoapi = TodoAPI()
    
    var body: some View {
        VStack {
            HStack {
                TextField("Todo...", text: $addtodo)
                
                Button(action: {
                    todoapi.savetodo(addtodo: addtodo)
                }, label: {
                    Text("Add")
                })
            }
            
            HStack {
                Spacer()
                Button(action: {
                    todoapi.filterTodo(newfilter: .all)
                }, label: {
                    Text("All")
                })
                Spacer()
                Button(action: {
                    todoapi.filterTodo(newfilter: .notdone)
                }, label: {
                    Text("Not done")
                })
                Spacer()
                Button(action: {
                    todoapi.filterTodo(newfilter: .done)
                }, label: {
                    Text("Done")
                })
                Spacer()
            }
            
            List {
                ForEach(todoapi.todoitems, id: \.self.title) { todo in
                    HStack {
                        Text(todo.title)
                        
                        Spacer()
                        VStack {
                            if todo.isdone {
                                Text("KLAR")
                            } else {
                                Text("INTE KLAR")
                            }
                        }
                        .onTapGesture {
                            print("klick på " + todo.title)
                            todoapi.changeDone(doneitem: todo)
                        }
                        
                        Button(action: {
                            todoapi.deleteTodo(deleteitem: todo)
                        }, label: {
                            Text("X")
                        })
                        
                    }
                    
                    
                    
                }
            }
            
            Button(action: {
                do {
                    try Auth.auth().signOut()
                } catch {
                    
                }
            }, label: {
                Text("Logout")
            })
            
        }
        .padding()
        .onAppear() {
            //dofbstuff()
            todoapi.loadtodo()
        }
    }
    
    
    
}

#Preview {
    ContentView()
}


