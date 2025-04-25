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
    
    var todoDetail = DetailViewModel()
    
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
            todoDetail.guncelle(todo_id: id, todo_name: name)
                }
                // En baştaki sayfaya geri dön
                navigationController?.popToRootViewController(animated: true)
    }
   
    
}
