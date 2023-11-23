//
//  TodoAPI.swift
//  pia12firebase
//
//  Created by BillU on 2023-11-23.
//

import Foundation
import Firebase

enum TodoFilterType {
    case all, done, notdone
}

class TodoAPI : ObservableObject {
    
    var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    
    var alltodoitems = [Todoitem]()
    @Published var todoitems = [Todoitem]()

    var filtertype = TodoFilterType.all
    
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
            
            var temp1 = Todoitem()
            temp1.isdone = false
            temp1.title = "AAA"
            temp1.todoid = "A"

            var temp2 = Todoitem()
            temp2.isdone = true
            temp2.title = "BBB"
            temp2.todoid = "B"

            var allthetodo = [Todoitem]()
            allthetodo.append(temp1)
            allthetodo.append(temp2)

            self.alltodoitems = allthetodo
            doTodoFilter()
            
            return
        }
        
        var ref: DatabaseReference!

        ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("todolist").child(uid).getData(completion: { error, snapshot in
            /*
            if let thetodo = snapshot?.value as? String {
                addtodo = thetodo
            }
            */
            
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
}
