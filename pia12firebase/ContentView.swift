//
//  ContentView.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-20.
//

import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct ContentView: View {
    
    @State var addtodo = ""
            
    @StateObject var todoapi = TodoAPI()
    
    @State var theimage : UIImage?
    
    @State var galleryimage : Image?
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        VStack {
            
            if galleryimage != nil {
                galleryimage!
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
            }
            
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                                            Text("Välj bild")
                                        }
            
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
            
            testGetImage()
        }
        .task(id: selectedPhoto) {
                     galleryimage = try? await selectedPhoto?.loadTransferable(type: Image.self)
                    
                    testUpload(theimage: galleryimage!)

                }
    }
    
    func testGetImage() {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let frog = storageRef.child("frog.jpg")
        
        print("IMAGE DOWNLOAD")
        frog.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
              
              DispatchQueue.main.async {
                  theimage = UIImage(data: data!)
              }
              
              
              
              
              print(data!.count)
          }
        }
    }
    
    func testUpload(theimage : Image) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let saveimage = storageRef.child("bilden.jpg")
        
        
        /*
        let uploadTask = saveimage.putData(data, metadata: nil) { (metadata, error) in
            
            
        }
        */
        
    }
}

#Preview {
    ContentView()
}


