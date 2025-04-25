//
//  TodoSave.swift
//  ToDoApplication
//
//  Created by Yakup Atici on 19.04.2025.
//

import UIKit

class TodoSave: UIViewController {
    
    
    @IBOutlet weak var todoId: UITextField!
    
    
    
    @IBOutlet weak var todoName: UITextField!
    
    var todosave = SaveViewModel()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonTapped(_ sender: Any) {
        

        guard let todoNameText = todoName.text, !todoNameText.isEmpty,
                  let todoIdText = todoId.text, let todoIdInt = Int(todoIdText) else {
                // Kullanıcıya bir uyarı göstermek isteyebilirsin
                print("Lütfen geçerli bir ID ve ad girin.")
                return
            }

            todosave.kaydet(todo_id: todoIdInt, todo_name: todoNameText)
    }
   
}
   
