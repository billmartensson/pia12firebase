//
//  TodoAPI.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-23.
//

import Foundation
import Firebase
import FirebaseStorage

enum TodoFilterType {
    case all, done, notdone
}

class TodoAPI : ObservableObject {
    
    var testid = UUID().uuidString
    
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    
    var alltodoitems = [Todoitem]()
    @Published var todoitems = [Todoitem]()

    var filtertype = TodoFilterType.all
    
    @Published var testimage : UIImage?
    
    func savetodo(addtodo : String) {
        
        if addtodo == "" {
            // VARNA TOMT
            
            return
        }
        
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        var todothing = [String : Any]()
        todothing["todotitle"] = addtodo
        todothing["tododone"] = false

        let uid = Auth.auth().currentUser!.uid
        
        ref.child("todolist").child(uid).childByAutoId().setValue(todothing)
        
        loadtodo()

    }

    func filterTodo(newfilter : TodoFilterType) {
        filtertype = newfilter
        
        doTodoFilter()
    }
    
    func doTodoFilter() {
        if self.filtertype == .all {
            todoitems = alltodoitems
        }
        if self.filtertype == .done {
            todoitems = alltodoitems.filter { $0.isdone == true }
        }
        if self.filtertype == .notdone {
            todoitems = alltodoitems.filter { $0.isdone != true }
        }
        
        
    }
    
    
    func loadtodo() {
        
        if isPreview {
            self.alltodoitems = doexampletodo()
            doTodoFilter()
            
            return
        }
        
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        var uid = Auth.auth().currentUser!.uid
        
        //uid = "wsQcVYIKYTeDOJkr6QF3Inrvc2L2"
        
        ref.child("todolist").child(uid).getData(completion: { error, snapshot in
            /*
            if let thetodo = snapshot?.value as? String {
                addtodo = thetodo
            }
            */
            
            print(error)
            
            var allthetodo = [Todoitem]()

            for todochild in snapshot!.children {
                let childsnap = todochild as! DataSnapshot
                
                //print("EN TODO SAK")
                
                
                if let thetodo = childsnap.value as? [String : Any] {
                    
                    var temptodo = Todoitem()
                    temptodo.todoid = childsnap.key
                    temptodo.title = thetodo["todotitle"] as! String
                    temptodo.isdone = thetodo["tododone"] as! Bool

                    allthetodo.append(temptodo)
                }
            }
            
            self.alltodoitems = allthetodo
            self.doTodoFilter()
            
        })
        
        
    }

    
    func changeDone(doneitem : Todoitem) {
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser!.uid
        
        if doneitem.isdone == true {
            doneitem.isdone = false
        } else {
            doneitem.isdone = true
        }
        
        ref.child("todolist").child(uid).child(doneitem.todoid).child("tododone").setValue(doneitem.isdone)
        
        loadtodo()
        
    }
    
    func deleteTodo(deleteitem : Todoitem) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("todolist").child(uid).child(deleteitem.todoid).removeValue()
        
        loadtodo()
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
                  self.testimage = UIImage(data: data!)
              }
              
                          
              print(data!.count)
          }
        }
        
    }
    
    func getimageother() {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let frog = storageRef.child("frog.jpg")
        
        
    }
    
    
    /*
    func dofbstuff() {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        //ref.child("fruit").setValue("Banan")
        
        ref.child("fruit").getData(completion: { error, snapshot in
            var thefruit = snapshot?.value as! String
            
            print("THE FRUIT IS: " + thefruit)
        })
    }
    */
    
    
    func loginother(loginemail : String, loginpass : String) async -> Bool {
        do {
            let authresult = try await Auth.auth().signIn(withEmail: loginemail, password: loginpass)
            
            if Auth.auth().currentUser != nil {
                return true
            }
            
        } catch {
            // ERROR ERROR
        }
        
        return false
    }
    
    func dosomeloading() async {
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        do {
            let somedata = try await ref.child("people").child("USERID").getData()
            /*
            for person in somedata.children {
                let personsnap = person as! DataSnapshot
            }
            */
            let userdict = somedata.value as! [String: String]
            let kompisid = userdict["kompis"]
            let kompisdata = try await ref.child("people").child(kompisid!).getData()
            
            
        } catch {
            // ERROR
        }
    }
    
    
    var bilder = ["A", "B", "C", "D"]
    
    func laddabilder(imagenumber : Int) {
        
        /*
         loadimage("BILD") {
            
         }
         
         for bild in bilder {
            loadimage(bild) {
                
            }
         }
         
         for bild in bilder {
            let imagedata = await loadimage(bild)
         }
         
         */
        
        if imagenumber == bilder.count {
            print("VI ÄR NU KLARA")
            return
        }
        
        print("LADDA BILD")
        print(bilder[imagenumber])
        // {
            laddabilder(imagenumber: imagenumber + 1)
        // }
    }
    
    
    func doexampletodo() -> [Todoitem] {
        
        var examples = [Todoitem]()
        
        var temp1 = Todoitem()
        temp1.isdone = false
        temp1.title = "AAA"
        temp1.todoid = "A"

        var temp2 = Todoitem()
        temp2.isdone = true
        temp2.title = "BBB"
        temp2.todoid = "B"

        var allthetodo = [Todoitem]()
        examples.append(temp1)
        examples.append(temp2)
        
        return examples
        
    }
    
    
}
