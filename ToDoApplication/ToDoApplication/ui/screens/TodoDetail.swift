//
//  TodoDetail.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 19.04.2025.
//

import UIKit

class TodoDetail: UIViewController {
    
    
    @IBOutlet weak var todoID: UITextField!
    
    @IBOutlet weak var todoName: UITextField!
    
    var todo: Todos? // Seçilen todo burada tutulur
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
     
           if let tempTodo = todo {
               todoID.text = String(tempTodo.todo_id ?? 0)
               todoName.text = tempTodo.todo_name
           }
       }


    @IBAction func todoUpdate(_ sender: Any) {
        if let idText = todoID.text,
                   let name = todoName.text,
                   let id = Int(idText),
                   !name.isEmpty {
                    guncelle(todo_id: id, todo_name: name)
                }
                // En baştaki sayfaya geri dön
                navigationController?.popToRootViewController(animated: true)
    }
    func guncelle(todo_id: Int, todo_name: String) {
           print("Todo Güncellendi → ID: \(todo_id), Name: \(todo_name)")
           // Buraya veritabanı işlemleri, servis çağrısı vs. eklenebilir
       }
    
}
