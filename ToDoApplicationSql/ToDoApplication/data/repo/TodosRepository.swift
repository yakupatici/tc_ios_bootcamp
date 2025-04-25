//
//  TodosRepository.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 25.04.2025.
//



import Foundation
import RxSwift

class TodosRepository {
    var todosList = BehaviorSubject<[Todos]>(value: [Todos]())
    
    let db:FMDatabase?
    
    init(){
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniYolu = URL(fileURLWithPath: hedefYol).appendingPathComponent("todo_app.sqlite")
        db = FMDatabase(path: veritabaniYolu.path)
    }
    
    func kaydet(todo_id:Int,todo_name:String){
        db?.open()
        
        do{
            try db!.executeUpdate("INSERT INTO toDos (id,name) VALUES (?,?)", values: [todo_id,todo_name])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func guncelle(todo_id:Int,todo_name:String){
        db?.open()
        
        do{
            try db!.executeUpdate("UPDATE toDos SET name=?,id=? WHERE id=?", values: [todo_name,todo_id])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func ara(aramaKelimesi:String){
        db?.open()
        
        do {
            var liste = [Todos]()
            
            let result = try db!.executeQuery("SELECT * FROM toDos WHERE name LIKE '%\(aramaKelimesi)%'", values: nil)
            
            while result.next() {
                let todo_id = Int(result.string(forColumn: "id"))!
                let todo_name = result.string(forColumn: "name")!
               
                
                let todo = Todos(todo_id: todo_id, todo_name: todo_name)
                
                liste.append(todo)
            }
            
            todosList.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func sil(todo_id:Int){
        db?.open()
        
        do{
            try db!.executeUpdate("DELETE FROM toDos WHERE id=?", values: [todo_id])
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    func todosYukle(){
        db?.open()
        
        do {
            var liste = [Todos]()
            
            let result = try db!.executeQuery("SELECT * FROM toDos", values: nil)
            
            while result.next() {
                let todo_id = Int(result.string(forColumn: "id"))!
                let todo_name = result.string(forColumn: "name")!
                
                let todo = Todos(todo_id: todo_id, todo_name: todo_name)
                
                liste.append(todo)
            }
            
            todosList.onNext(liste)//Tetikleme
        }catch{
            print(error.localizedDescription)
        }
        
        db?.close()
    }
    
    
}
